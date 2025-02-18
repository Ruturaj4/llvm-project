//===-- RISCVLegalizerInfo.cpp ----------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the Machinelegalizer class for RISC-V.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "RISCVLegalizerInfo.h"
#include "RISCVSubtarget.h"
#include "llvm/CodeGen/TargetOpcodes.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Type.h"

using namespace llvm;

RISCVLegalizerInfo::RISCVLegalizerInfo(const RISCVSubtarget &ST) {
  const unsigned XLen = ST.getXLen();
  const LLT XLenLLT = LLT::scalar(XLen);
  const LLT p0 = LLT::pointer(0, XLen);

  using namespace TargetOpcode;

  getActionDefinitionsBuilder({G_ADD, G_SUB, G_AND, G_OR, G_XOR})
      .legalFor({XLenLLT})
      .widenScalarToNextPow2(0)
      .clampScalar(0, XLenLLT, XLenLLT);

  getActionDefinitionsBuilder(
      {G_UADDE, G_UADDO, G_USUBE, G_USUBO, G_SADDE, G_SADDO, G_SSUBE, G_SSUBO})
      .legalFor({{XLenLLT, XLenLLT}})
      .clampScalar(0, XLenLLT, XLenLLT)
      .clampScalar(1, XLenLLT, XLenLLT)
      .widenScalarToNextPow2(0);

  getActionDefinitionsBuilder({G_ASHR, G_LSHR, G_SHL})
      .legalFor({{XLenLLT, XLenLLT}})
      .widenScalarToNextPow2(0)
      .clampScalar(1, XLenLLT, XLenLLT)
      .clampScalar(0, XLenLLT, XLenLLT);

  getActionDefinitionsBuilder({G_ZEXT, G_SEXT, G_ANYEXT})
      .maxScalar(0, XLenLLT);

  getActionDefinitionsBuilder(G_SEXT_INREG)
      .legalFor({XLenLLT})
      .maxScalar(0, XLenLLT)
      .lower();

  // Merge/Unmerge
  for (unsigned Op : {G_MERGE_VALUES, G_UNMERGE_VALUES}) {
    unsigned BigTyIdx = Op == G_MERGE_VALUES ? 0 : 1;
    unsigned LitTyIdx = Op == G_MERGE_VALUES ? 1 : 0;
    getActionDefinitionsBuilder(Op)
        .widenScalarToNextPow2(LitTyIdx, XLen)
        .widenScalarToNextPow2(BigTyIdx, XLen)
        .clampScalar(LitTyIdx, XLenLLT, XLenLLT)
        .clampScalar(BigTyIdx, XLenLLT, XLenLLT);
  }

  getActionDefinitionsBuilder({G_CONSTANT, G_IMPLICIT_DEF})
      .legalFor({XLenLLT, p0})
      .widenScalarToNextPow2(0)
      .clampScalar(0, XLenLLT, XLenLLT);

  getActionDefinitionsBuilder(G_ICMP)
      .legalFor({{XLenLLT, XLenLLT}})
      .widenScalarToNextPow2(1)
      .clampScalar(1, XLenLLT, XLenLLT)
      .clampScalar(0, XLenLLT, XLenLLT);

  getActionDefinitionsBuilder(G_SELECT)
      .legalFor({{XLenLLT, XLenLLT}})
      .widenScalarToNextPow2(0)
      .clampScalar(0, XLenLLT, XLenLLT)
      .clampScalar(1, XLenLLT, XLenLLT);

  getActionDefinitionsBuilder(G_BRCOND)
      .legalFor({XLenLLT})
      .minScalar(0, XLenLLT);

  getActionDefinitionsBuilder(G_PHI)
      .legalFor({p0, XLenLLT})
      .widenScalarToNextPow2(0)
      .clampScalar(0, XLenLLT, XLenLLT);

  getLegacyLegalizerInfo().computeTables();
}
