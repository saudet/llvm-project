; RUN: llc < %s -mtriple=ve-unknown-unknown -mattr=+packed | FileCheck %s
; ModuleID = 'gen/tests/vdivswzx_vsvl.c'
source_filename = "gen/tests/vdivswzx_vsvl.c"
target datalayout = "e-m:e-i64:64-n32:64-S128-v64:64:64-v128:64:64-v256:64:64-v512:64:64-v1024:64:64-v2048:64:64-v4096:64:64-v8192:64:64-v16384:64:64"
target triple = "ve-unknown-linux-gnu"

; Function Attrs: nounwind
define dso_local void @vdivswzx_vsvl(i32* %0, i32 signext %1, i32* %2, i32 signext %3) local_unnamed_addr #0 {
; CHECK: vdivs.w.zx %v0, %s1, %v0
  %5 = icmp sgt i32 %3, 0
  br i1 %5, label %7, label %6

6:                                                ; preds = %7, %4
  ret void

7:                                                ; preds = %4, %7
  %8 = phi i32* [ %18, %7 ], [ %0, %4 ]
  %9 = phi i32* [ %19, %7 ], [ %2, %4 ]
  %10 = phi i32 [ %20, %7 ], [ 0, %4 ]
  %11 = sub nsw i32 %3, %10
  %12 = icmp slt i32 %11, 256
  %13 = select i1 %12, i32 %11, i32 256
  %14 = bitcast i32* %9 to i8*
  %15 = tail call <256 x double> @llvm.ve.vl.vldlsx.vssl(i64 4, i8* %14, i32 %13)
  %16 = tail call <256 x double> @llvm.ve.vl.vdivswzx.vsvl(i32 %1, <256 x double> %15, i32 %13)
  %17 = bitcast i32* %8 to i8*
  tail call void @llvm.ve.vl.vstl.vssl(<256 x double> %16, i64 4, i8* %17, i32 %13)
  %18 = getelementptr inbounds i32, i32* %8, i64 256
  %19 = getelementptr inbounds i32, i32* %9, i64 256
  %20 = add nuw nsw i32 %10, 256
  %21 = icmp slt i32 %20, %3
  br i1 %21, label %7, label %6
}

; Function Attrs: nounwind readonly
declare <256 x double> @llvm.ve.vl.vldlsx.vssl(i64, i8*, i32) #1

; Function Attrs: nounwind readnone
declare <256 x double> @llvm.ve.vl.vdivswzx.vsvl(i32, <256 x double>, i32) #2

; Function Attrs: nounwind writeonly
declare void @llvm.ve.vl.vstl.vssl(<256 x double>, i64, i8*, i32) #3

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="-vec" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readonly }
attributes #2 = { nounwind readnone }
attributes #3 = { nounwind writeonly }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 12.0.0 (git@socsv218.svp.cl.nec.co.jp:ve-llvm/llvm-project.git ea1e45464a3c0492368cbabae9242628b03e399d)"}
