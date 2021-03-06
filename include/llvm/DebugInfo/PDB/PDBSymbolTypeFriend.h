//===- PDBSymbolTypeFriend.h - friend type info -----------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DEBUGINFO_PDB_PDBSYMBOLTYPEFRIEND_H
#define LLVM_DEBUGINFO_PDB_PDBSYMBOLTYPEFRIEND_H

#include "PDBSymbol.h"
#include "PDBTypes.h"

namespace llvm {

class PDBSymbolTypeFriend : public PDBSymbol {
public:
  PDBSymbolTypeFriend(std::unique_ptr<IPDBRawSymbol> FriendTypeSymbol);

  FORWARD_SYMBOL_METHOD(getClassParentId)
  FORWARD_SYMBOL_METHOD(getName)
  FORWARD_SYMBOL_METHOD(getSymIndexId)
  FORWARD_SYMBOL_METHOD(getTypeId)

  static bool classof(const PDBSymbol *S) {
    return S->getSymTag() == PDB_SymType::Friend;
  }
};

} // namespace llvm

#endif // LLVM_DEBUGINFO_PDB_PDBSYMBOLTYPEFRIEND_H
