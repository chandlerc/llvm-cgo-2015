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
#include "llvm/Support/Debug.h"
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
    AU.setPreservesCFG();
  }
};
}

bool LazyCM::runOnFunction(Function &F) {
  bool Changed = false;

  DEBUG(dbgs() << "Beginning Lazy Code Motion for function: " << F.getName()
               << "\n");

  // Do something here!

  return Changed;
}

char LazyCM::ID = 0;

FunctionPass *llvm::createLazyCMPass() { return new LazyCM(); }

INITIALIZE_PASS_BEGIN(LazyCM, "lcm", "Lazy Code Motion", false, false)
INITIALIZE_PASS_END(LazyCM, "lcm", "LazyCodeMotion", false, false)
