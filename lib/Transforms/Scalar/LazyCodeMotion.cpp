//===-- LazyCodeMotion.cpp - Naive Lazy Code Motion -------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements a naive, aggressive lazy code motion pass.
///
/// No attempt is made to model any costs or tradeoffs, the goal is to be as
/// lazy as possible.
///
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/Scalar.h"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/Support/Debug.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Pass.h"

using namespace llvm;

#define DEBUG_TYPE "lcm"

namespace {
/// \brief A Lazy Code Motion pass implementation.
class LazyCM : public FunctionPass {
public:
  static char ID;

  LazyCM() : FunctionPass(ID) {
    initializeLazyCMPass(*PassRegistry::getPassRegistry());
  }

  bool runOnFunction(Function &F) override;

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<DominatorTreeWrapperPass>();
    AU.setPreservesCFG();
  }
};
}

bool LazyCM::runOnFunction(Function &F) {
  bool Changed = false;

  DominatorTree &DT = getAnalysis<DominatorTreeWrapperPass>().getDomTree();

  DEBUG(dbgs() << "Beginning Lazy Code Motion for function: " << F.getName()
               << "\n");

  for (auto POI = po_begin(&F), POE = po_end(&F); POI != POE; ++POI) {
    BasicBlock &BB = **POI;
    for (auto II = std::next(BB.rbegin()), IE = BB.rend(); II != IE; ++II) {
      Instruction &I = *II;
      DEBUG(dbgs() << "Inspecting instruction: " << I << "\n");

      if (I.use_empty())
        continue;

      // Set the dominating BB to the parent BB of the first use.
      BasicBlock *DomBB = cast<Instruction>(I.user_back())->getParent();

      // Now keep finding the common dominator across the common dominator so
      // far and the block contaning every user.
      for (User *U : I.users()) {
        DEBUG(dbgs() << "    User: " << *U << "\n");
        DomBB = DT.findNearestCommonDominator(
            DomBB, cast<Instruction>(U)->getParent());
        if (!DomBB)
          // Once we hit null, there is no common dominator.
          break;
      }
      if (!DomBB || DomBB == &BB)
        // Never found an interesting common dominator, move on to the next
        // instruction.
        continue;

      DEBUG(dbgs() << "    Dominating BB: " << DomBB->getName() << "\n");

      // Scan the dominating basic block and stop at the terminator or first
      // user.
      Instruction *InsertPoint = nullptr;
      for (Instruction &DomBBI : *DomBB) {
        // If this is the terminator, we're done.
        if (&DomBBI == DomBB->getTerminator()) {
          InsertPoint = &DomBBI;
          break;
        }

        // Check if this instruction is using I.
        for (Value *Operand : DomBBI.operand_values())
          if (Operand == &I) {
            InsertPoint = &DomBBI;
            break;
          }
        if (InsertPoint)
          break;
      }
      assert(InsertPoint && "Didn't correctly locate an insert point!");

      // If the insert point is a PHI node, we have to find a common dominator
      // for all of the predecessors which have incoming uses.
      if (isa<PHINode>(InsertPoint)) {
        DomBB = nullptr;
        // We have to potentially scan multiple PHI node users in the same
        // basic block and take the common dominator for all their incoming uses.
        while (auto *PHI = dyn_cast<PHINode>(InsertPoint)) {
          for (int i = 0, NumIncoming = PHI->getNumIncomingValues();
               i < NumIncoming; ++i) {
            if (PHI->getIncomingValue(i) != &I)
              continue;

            BasicBlock *IncomingBB = PHI->getIncomingBlock(i);
            DomBB = DomBB ? DT.findNearestCommonDominator(DomBB, IncomingBB)
                          : IncomingBB;
            if (!DomBB)
              break;
          }
          if (!DomBB)
            break;
          InsertPoint = std::next(BasicBlock::iterator(InsertPoint));
        }
        if (!DomBB || DomBB == &BB) {
          DEBUG(dbgs() << "    PHI node needs incoming values with no common "
                          "dominator!\n");
          continue;
        }

        // We know nothing in this block uses I because there it properly
        // dominates the common dominator of all users. Just insert before the
        // terminator.
        InsertPoint = DomBB->getTerminator();
      }

      DEBUG(dbgs() << "    Sinking to: " << *InsertPoint << "\n");

      // Back up the iterator as we're about to remove the intruction it points
      // at.
      --II;

      I.moveBefore(InsertPoint);

      // Reset the end iterator as well.
      IE = BB.rend();
    }
  }

  return Changed;
}

char LazyCM::ID = 0;

FunctionPass *llvm::createLazyCMPass() { return new LazyCM(); }

INITIALIZE_PASS_BEGIN(LazyCM, "lcm", "Lazy Code Motion", false, false)
INITIALIZE_PASS_DEPENDENCY(DominatorTreeWrapperPass)
INITIALIZE_PASS_END(LazyCM, "lcm", "LazyCodeMotion", false, false)
