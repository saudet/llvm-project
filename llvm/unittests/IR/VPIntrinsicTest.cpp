//===- VPIntrinsicTest.cpp - VPIntrinsic unit tests ---------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/SmallVector.h"
#include "llvm/AsmParser/Parser.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/SourceMgr.h"
#include "gtest/gtest.h"

using namespace llvm;

namespace {

class VPIntrinsicTest : public testing::Test {
protected:
  LLVMContext Context;

  VPIntrinsicTest() : Context() {}

  LLVMContext C;
  SMDiagnostic Err;

  std::unique_ptr<Module> CreateVPDeclarationModule() {
      return parseAssemblyString(
" declare <8 x double> @llvm.vp.fadd.v8f64(<8 x double>, <8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.fsub.v8f64(<8 x double>, <8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.fmul.v8f64(<8 x double>, <8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.fdiv.v8f64(<8 x double>, <8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.frem.v8f64(<8 x double>, <8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.fma.v8f64(<8 x double>, <8 x double>, <8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.fneg.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.minnum.v8f64(<8 x double>, <8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.maxnum.v8f64(<8 x double>, <8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x i32> @llvm.vp.add.v8i32(<8 x i32>, <8 x i32>, <8 x i1> mask, i32 vlen) "
" declare <8 x i32> @llvm.vp.sub.v8i32(<8 x i32>, <8 x i32>, <8 x i1> mask, i32 vlen) "
" declare <8 x i32> @llvm.vp.mul.v8i32(<8 x i32>, <8 x i32>, <8 x i1> mask, i32 vlen) "
" declare <8 x i32> @llvm.vp.sdiv.v8i32(<8 x i32>, <8 x i32>, <8 x i1> mask, i32 vlen) "
" declare <8 x i32> @llvm.vp.srem.v8i32(<8 x i32>, <8 x i32>, <8 x i1> mask, i32 vlen) "
" declare <8 x i32> @llvm.vp.udiv.v8i32(<8 x i32>, <8 x i32>, <8 x i1> mask, i32 vlen) "
" declare <8 x i32> @llvm.vp.urem.v8i32(<8 x i32>, <8 x i32>, <8 x i1> mask, i32 vlen) "
" declare <8 x i32> @llvm.vp.and.v8i32(<8 x i32>, <8 x i32>, <8 x i1> mask, i32 vlen) "
" declare <8 x i32> @llvm.vp.xor.v8i32(<8 x i32>, <8 x i32>, <8 x i1> mask, i32 vlen) "
" declare <8 x i32> @llvm.vp.or.v8i32(<8 x i32>, <8 x i32>, <8 x i1> mask, i32 vlen) "
" declare <8 x i32> @llvm.vp.ashr.v8i32(<8 x i32>, <8 x i32>, <8 x i1> mask, i32 vlen)  "
" declare <8 x i32> @llvm.vp.lshr.v8i32(<8 x i32>, <8 x i32>, <8 x i1> mask, i32 vlen)  "
" declare <8 x i32> @llvm.vp.shl.v8i32(<8 x i32>, <8 x i32>, <8 x i1> mask, i32 vlen) "
" declare void @llvm.vp.store.v16i32.p0v16i32(<16 x i32>, <16 x i32>*, <16 x i1> mask, i32 vlen) "
" declare void @llvm.vp.scatter.v16i32.v16p0i32(<16 x i32>, <16 x i32*>, <16 x i1> mask, i32 vlen) "
" declare <16 x i32> @llvm.vp.load.v16i32.p0v16i32(<16 x i32>*, <16 x i1> mask, i32 vlen) "
" declare <16 x i32> @llvm.vp.gather.v16i32.v16p0i32(<16 x i32*>, <16 x i1> mask, i32 vlen) "
" declare float @llvm.vp.reduce.fadd.v16f32(float, <16 x float>, <16 x i1> mask, i32 vlen)  "
" declare float @llvm.vp.reduce.fmul.v16f32(float, <16 x float>, <16 x i1> mask, i32 vlen) "
" declare float @llvm.vp.reduce.fmin.v16f32(<16 x float>, <16 x i1> mask, i32 vlen) "
" declare float @llvm.vp.reduce.fmax.v16f32(<16 x float>, <16 x i1> mask, i32 vlen) "
" declare i32 @llvm.vp.reduce.add.v16i32(<16 x i32>, <16 x i1> mask, i32 vlen) "
" declare i32 @llvm.vp.reduce.mul.v16i32(<16 x i32>, <16 x i1> mask, i32 vlen) "
" declare i32 @llvm.vp.reduce.and.v16i32(<16 x i32>, <16 x i1> mask, i32 vlen) "
" declare i32 @llvm.vp.reduce.xor.v16i32(<16 x i32>, <16 x i1> mask, i32 vlen) "
" declare i32 @llvm.vp.reduce.or.v16i32(<16 x i32>, <16 x i1> mask, i32 vlen) "
" declare i32 @llvm.vp.reduce.smin.v16i32(<16 x i32>, <16 x i1> mask, i32 vlen) "
" declare i32 @llvm.vp.reduce.smax.v16i32(<16 x i32>, <16 x i1> mask, i32 vlen) "
" declare i32 @llvm.vp.reduce.umin.v16i32(<16 x i32>, <16 x i1> mask, i32 vlen) "
" declare i32 @llvm.vp.reduce.umax.v16i32(<16 x i32>, <16 x i1> mask, i32 vlen) "
" declare <16 x float> @llvm.vp.select.v16f32(<16 x float>, <16 x float>, <16 x i1>, i32, i32 vlen) "
" declare <16 x float> @llvm.vp.vshift.v16f32(<16 x float>, i32, <16 x i1>, i32 vlen) "
" declare <16 x float> @llvm.vp.compress.v16f32(<16 x float>, <16 x i1>, i32 vlen) "
" declare <16 x float> @llvm.vp.expand.v16f32(<16 x float>, <16 x i1> mask, i32 vlen) "
" declare <16 x i1> @llvm.vp.icmp.v16i32(<16 x i32>, <16 x i32>, i8, <16 x i1> mask, i32 vlen) "
" declare <16 x i1> @llvm.vp.fcmp.v16f32(<16 x float>, <16 x float>, i8, <16 x i1> mask, i32 vlen) "
" declare <8 x i64> @llvm.vp.fptosi.v8i64v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x i64> @llvm.vp.fptoui.v8i64v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.sitofp.v8f64v8i64(<8 x i64>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.uitofp.v8f64v8i64(<8 x i64>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.rint.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.round.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.nearbyint.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.ceil.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.floor.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.trunc.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x float> @llvm.vp.fptrunc.v8f32v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.fpext.v8f64v8f32(<8 x float>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.pow.v8f64(<8 x double>, <8 x double> %y, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.powi.v8f64(<8 x double>, i32 %y, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.sqrt.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.sin.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.cos.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.log.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.log10.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.log2.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.exp.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) "
" declare <8 x double> @llvm.vp.exp2.v8f64(<8 x double>, <8 x i1> mask, i32 vlen) ",
          Err, C);
  }
};

/// Check that VPIntrinsic:canIgnoreVectorLengthParam() returns true
/// if the vector length parameter does not mask off any lanes.
TEST_F(VPIntrinsicTest, CanIgnoreVectorLength) {
  LLVMContext C;
  SMDiagnostic Err;

  std::unique_ptr<Module> M =
      parseAssemblyString(
"declare <256 x i64> @llvm.vp.mul.v256i64(<256 x i64>, <256 x i64>, <256 x i1>, i32)"
"declare <vscale x 2 x i64> @llvm.vp.mul.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i1>, i32)"
"declare <vscale x 1 x i64> @llvm.vp.mul.nxv1i64(<vscale x 1 x i64>, <vscale x 1 x i64>, <vscale x 1 x i1>, i32)"
"declare i32 @llvm.vscale.i32()"
"define void @test_static_vlen( "
"      <256 x i64> %i0, <vscale x 2 x i64> %si0x2, <vscale x 1 x i64> %si0x1,"
"      <256 x i64> %i1, <vscale x 2 x i64> %si1x2, <vscale x 1 x i64> %si1x1,"
"      <256 x i1> %m, <vscale x 2 x i1> %smx2, <vscale x 1 x i1> %smx1, i32 %vl) { "
"  %r0 = call <256 x i64> @llvm.vp.mul.v256i64(<256 x i64> %i0, <256 x i64> %i1, <256 x i1> %m, i32 %vl)"
"  %r1 = call <256 x i64> @llvm.vp.mul.v256i64(<256 x i64> %i0, <256 x i64> %i1, <256 x i1> %m, i32 256)"
"  %r2 = call <256 x i64> @llvm.vp.mul.v256i64(<256 x i64> %i0, <256 x i64> %i1, <256 x i1> %m, i32 0)"
"  %r3 = call <256 x i64> @llvm.vp.mul.v256i64(<256 x i64> %i0, <256 x i64> %i1, <256 x i1> %m, i32 7)"
"  %r4 = call <256 x i64> @llvm.vp.mul.v256i64(<256 x i64> %i0, <256 x i64> %i1, <256 x i1> %m, i32 123)"
"  %vs = call i32 @llvm.vscale.i32()"
"  %vs.x2 = mul i32 %vs, 2"
"  %r5 = call <vscale x 2 x i64> @llvm.vp.mul.nxv2i64(<vscale x 2 x i64> %si0x2, <vscale x 2 x i64> %si1x2, <vscale x 2 x i1> %smx2, i32 %vs.x2)"
"  %r6 = call <vscale x 2 x i64> @llvm.vp.mul.nxv2i64(<vscale x 2 x i64> %si0x2, <vscale x 2 x i64> %si1x2, <vscale x 2 x i1> %smx2, i32 %vs)"
"  %r7 = call <vscale x 2 x i64> @llvm.vp.mul.nxv2i64(<vscale x 2 x i64> %si0x2, <vscale x 2 x i64> %si1x2, <vscale x 2 x i1> %smx2, i32 99999)"
"  %r8 = call <vscale x 1 x i64> @llvm.vp.mul.nxv1i64(<vscale x 1 x i64> %si0x1, <vscale x 1 x i64> %si1x1, <vscale x 1 x i1> %smx1, i32 %vs)"
"  %r9 = call <vscale x 1 x i64> @llvm.vp.mul.nxv1i64(<vscale x 1 x i64> %si0x1, <vscale x 1 x i64> %si1x1, <vscale x 1 x i1> %smx1, i32 1)"
"  %r10 = call <vscale x 1 x i64> @llvm.vp.mul.nxv1i64(<vscale x 1 x i64> %si0x1, <vscale x 1 x i64> %si1x1, <vscale x 1 x i1> %smx1, i32 %vs.x2)"
"  %vs.wat = add i32 %vs, 2"
"  %r11 = call <vscale x 2 x i64> @llvm.vp.mul.nxv2i64(<vscale x 2 x i64> %si0x2, <vscale x 2 x i64> %si1x2, <vscale x 2 x i1> %smx2, i32 %vs.wat)"
"  ret void "
"}",
          Err, C);

  auto *F = M->getFunction("test_static_vlen");
  assert(F);

  const int NumExpected = 12;
  const bool Expected[] = {false, true, false, false, false, true, false, false, true, false, true, false};
  int i = 0;
  for (auto &I : F->getEntryBlock()) {
    VPIntrinsic *VPI = dyn_cast<VPIntrinsic>(&I);
    if (!VPI)
      continue;

    ASSERT_LT(i, NumExpected);
    ASSERT_EQ(Expected[i], VPI->canIgnoreVectorLengthParam());
    ++i;
  }
}

/// Check that the argument returned by
/// VPIntrinsic::Get<X>ParamPos(Intrinsic::ID) has the expected type.
TEST_F(VPIntrinsicTest, GetParamPos) {
  std::unique_ptr<Module> M = CreateVPDeclarationModule();
  assert(M);

  for (Function &F : *M) {
    ASSERT_TRUE(F.isIntrinsic());
    Optional<int> MaskParamPos =
        VPIntrinsic::GetMaskParamPos(F.getIntrinsicID());
    if (MaskParamPos) {
      Type *MaskParamType = F.getArg(*MaskParamPos)->getType();
      ASSERT_TRUE(MaskParamType->isVectorTy());
      ASSERT_TRUE(cast<VectorType>(MaskParamType)->getElementType()->isIntegerTy(1));
    }

    Optional<int> VecLenParamPos =
        VPIntrinsic::GetVectorLengthParamPos(F.getIntrinsicID());
    if (VecLenParamPos) {
      Type *VecLenParamType = F.getArg(*VecLenParamPos)->getType();
      ASSERT_TRUE(VecLenParamType->isIntegerTy(32));
    }

    Optional<int> MemPtrParamPos = VPIntrinsic::GetMemoryPointerParamPos(F.getIntrinsicID());
    if (MemPtrParamPos) {
      Type *MemPtrParamType = F.getArg(*MemPtrParamPos)->getType();
      ASSERT_TRUE(MemPtrParamType->isPtrOrPtrVectorTy());
    }
  }
}

/// Check that going from Opcode to VP intrinsic and back results in the same
/// Opcode.
TEST_F(VPIntrinsicTest, OpcodeRoundTrip) {
  std::vector<unsigned> Opcodes;
  Opcodes.reserve(100);

  {
#define HANDLE_INST(OCNum, OCName, Class) Opcodes.push_back(OCNum);
#include "llvm/IR/Instruction.def"
  }

  unsigned FullTripCounts = 0;
  for (unsigned OC : Opcodes) {
    Intrinsic::ID VPID = VPIntrinsic::GetForOpcode(OC);
    // no equivalent VP intrinsic available
    if (VPID == Intrinsic::not_intrinsic)
      continue;

    unsigned RoundTripOC = VPIntrinsic::GetFunctionalOpcodeForVP(VPID);
    // no equivalent Opcode available
    if (RoundTripOC == Instruction::Call)
      continue;

    ASSERT_EQ(RoundTripOC, OC);
    ++FullTripCounts;
  }
  ASSERT_NE(FullTripCounts, 0u);
}

} // end anonymous namespace
