//===-- VERegisterInfo.h - VE Register Information Impl ---------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the VE implementation of the TargetRegisterInfo class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_VE_VEREGISTERINFO_H
#define LLVM_LIB_TARGET_VE_VEREGISTERINFO_H

#include "llvm/CodeGen/TargetRegisterInfo.h"

#define GET_REGINFO_HEADER
#include "VEGenRegisterInfo.inc"

struct MIBuilder;

namespace llvm {
struct VERegisterInfo : public VEGenRegisterInfo {
  VERegisterInfo();

  /// Code Generation virtual methods...
  const MCPhysReg *getCalleeSavedRegs(const MachineFunction *MF) const override;
  const uint32_t *getCallPreservedMask(const MachineFunction &MF,
                                       CallingConv::ID CC) const override;
  const uint32_t *getNoPreservedMask() const override;

  BitVector getReservedRegs(const MachineFunction &MF) const override;
  bool isConstantPhysReg(MCRegister PhysReg) const override;

  const TargetRegisterClass *getPointerRegClass(const MachineFunction &MF,
                                                unsigned Kind) const override;

  bool requiresRegisterScavenging(const MachineFunction &MF) const override;
  bool requiresFrameIndexScavenging(const MachineFunction &MF) const override;

  void eliminateFrameIndex(MachineBasicBlock::iterator II, int SPAdj,
                           unsigned FIOperandNum,
                           RegScavenger *RS = nullptr) const override;

  Register getFrameRegister(const MachineFunction &MF) const override;

  unsigned getRegPressureSetLimit(const MachineFunction &MF,
                                  unsigned Idx) const override;
  bool
  getRegAllocationHints(Register VirtReg, ArrayRef<MCPhysReg> Order,
                        SmallVectorImpl<MCPhysReg> &Hints,
                        const MachineFunction &MF,
                        const VirtRegMap *VRM = nullptr,
                        const LiveRegMatrix *Matrix = nullptr) const override;

private:
  void eliminateFrameIndex_VM512(MachineInstr &MI, MIBuilder &MIB,
                                 Register FrameReg, int Offset,
                                 int FIOperandNum) const;
  void eliminateFrameIndex_VM(MachineInstr &MI, MIBuilder &MIB,
                              Register FrameReg, int Offset,
                              int FIOperandNum) const;
  void eliminateFrameIndex_Q(MachineInstr &MI, MIBuilder &MIB,
                             Register FrameReg, int Offset,
                             int FIOperandNum) const;
  void eliminateFrameIndex_V64(MachineInstr &MI, MIBuilder &MIB,
                               Register FrameReg, int Offset,
                               int FIOperandNum) const;
  void eliminateFrameIndex_VP(MachineInstr &MI, MIBuilder &MIB,
                              Register FrameReg, int Offset,
                              int FIOperandNum) const;
};

} // namespace llvm

#endif
