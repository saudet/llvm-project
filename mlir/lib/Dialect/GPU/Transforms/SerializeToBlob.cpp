//===- SerializeToBlob.cpp - MLIR GPU lowering pass -----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements a base class for a pass to serialize a gpu module
// into a binary blob that can be executed on a GPU. The binary blob is added
// as a string attribute to the gpu module.
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/GPU/Passes.h"
#include "mlir/Pass/Pass.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Target/TargetMachine.h"

using namespace mlir;

std::string gpu::getDefaultGpuBinaryAnnotation() { return "gpu.binary"; }

gpu::SerializeToBlobPass::SerializeToBlobPass(TypeID passID)
    : OperationPass<gpu::GPUModuleOp>(passID) {}

gpu::SerializeToBlobPass::SerializeToBlobPass(const SerializeToBlobPass &other)
    : OperationPass<gpu::GPUModuleOp>(other) {
  // Pass::Option has no copy constructor, copy them manually.
  triple = other.triple;
  chip = other.chip;
  features = other.features;
  gpuBinaryAnnotation = other.gpuBinaryAnnotation;
}

static std::string translateToISA(llvm::Module &llvmModule,
                                  llvm::TargetMachine &targetMachine) {
  llvmModule.setDataLayout(targetMachine.createDataLayout());

  std::string targetISA;
  llvm::raw_string_ostream stream(targetISA);
  llvm::buffer_ostream pstream(stream);
  llvm::legacy::PassManager codegenPasses;
  targetMachine.addPassesToEmitFile(codegenPasses, pstream, nullptr,
                                    llvm::CGFT_AssemblyFile);
  codegenPasses.run(llvmModule);
  return targetISA;
}

void gpu::SerializeToBlobPass::runOnOperation() {
  // Lower the module to an LLVM IR module using a separate context to enable
  // multi-threaded processing.
  llvm::LLVMContext llvmContext;
  std::unique_ptr<llvm::Module> llvmModule = translateToLLVMIR(llvmContext);
  if (!llvmModule)
    return signalPassFailure();

  // Lower the LLVM IR module to target ISA.
  std::unique_ptr<llvm::TargetMachine> targetMachine = createTargetMachine();
  if (!targetMachine)
    return signalPassFailure();

  std::string targetISA = translateToISA(*llvmModule, *targetMachine);

  // Serialize the target ISA.
  std::unique_ptr<std::vector<char>> blob = serializeISA(targetISA);
  if (!blob)
    return signalPassFailure();

  // Add the blob as module attribute.
  auto attr = StringAttr::get(&getContext(), {blob->data(), blob->size()});
  getOperation()->setAttr(gpuBinaryAnnotation, attr);
}

std::unique_ptr<llvm::TargetMachine>
gpu::SerializeToBlobPass::createTargetMachine() {
  Location loc = getOperation().getLoc();
  std::string error;
  const llvm::Target *target =
      llvm::TargetRegistry::lookupTarget(triple, error);
  if (!target) {
    emitError(loc, Twine("failed to lookup target: ") + error);
    return {};
  }
  llvm::TargetMachine *machine =
      target->createTargetMachine(triple, chip, features, {}, {});
  if (!machine) {
    emitError(loc, "failed to create target machine");
    return {};
  }

  return std::unique_ptr<llvm::TargetMachine>{machine};
}
