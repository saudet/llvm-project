; RUN: llc < %s -mtriple=ve-unknown-unknown -mattr=+packed | FileCheck %s
; ModuleID = 'gen/tests/pvrsqrtnex_vvl.c'
source_filename = "gen/tests/pvrsqrtnex_vvl.c"
target datalayout = "e-m:e-i64:64-n32:64-S128-v64:64:64-v128:64:64-v256:64:64-v512:64:64-v1024:64:64-v2048:64:64-v4096:64:64-v8192:64:64-v16384:64:64"
target triple = "ve-unknown-linux-gnu"

; Function Attrs: nounwind
define dso_local void @pvrsqrtnex_vvl(float* %0, float* %1, i32 signext %2) local_unnamed_addr #0 {
; CHECK: pvrsqrt.nex %v0, %v0
  %4 = icmp sgt i32 %2, 0
  br i1 %4, label %6, label %5

5:                                                ; preds = %6, %3
  ret void

6:                                                ; preds = %3, %6
  %7 = phi float* [ %18, %6 ], [ %0, %3 ]
  %8 = phi float* [ %19, %6 ], [ %1, %3 ]
  %9 = phi i32 [ %20, %6 ], [ 0, %3 ]
  %10 = sub nsw i32 %2, %9
  %11 = icmp slt i32 %10, 512
  %12 = ashr i32 %10, 1
  %13 = select i1 %11, i32 %12, i32 256
  %14 = bitcast float* %8 to i8*
  %15 = tail call <256 x double> @llvm.ve.vl.vld.vssl(i64 8, i8* %14, i32 %13)
  %16 = tail call <256 x double> @llvm.ve.vl.pvrsqrtnex.vvl(<256 x double> %15, i32 %13)
  %17 = bitcast float* %7 to i8*
  tail call void @llvm.ve.vl.vst.vssl(<256 x double> %16, i64 8, i8* %17, i32 %13)
  %18 = getelementptr inbounds float, float* %7, i64 512
  %19 = getelementptr inbounds float, float* %8, i64 512
  %20 = add nuw nsw i32 %9, 512
  %21 = icmp slt i32 %20, %2
  br i1 %21, label %6, label %5
}

; Function Attrs: nounwind readonly
declare <256 x double> @llvm.ve.vl.vld.vssl(i64, i8*, i32) #1

; Function Attrs: nounwind readnone
declare <256 x double> @llvm.ve.vl.pvrsqrtnex.vvl(<256 x double>, i32) #2

; Function Attrs: nounwind writeonly
declare void @llvm.ve.vl.vst.vssl(<256 x double>, i64, i8*, i32) #3

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="-vec" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readonly }
attributes #2 = { nounwind readnone }
attributes #3 = { nounwind writeonly }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 12.0.0 (git@socsv218.svp.cl.nec.co.jp:ve-llvm/llvm-project.git ea1e45464a3c0492368cbabae9242628b03e399d)"}
