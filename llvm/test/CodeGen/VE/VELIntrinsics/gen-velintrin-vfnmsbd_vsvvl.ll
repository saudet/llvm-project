; RUN: llc < %s -mtriple=ve-unknown-unknown -mattr=+packed | FileCheck %s
; ModuleID = 'gen/tests/vfnmsbd_vsvvl.c'
source_filename = "gen/tests/vfnmsbd_vsvvl.c"
target datalayout = "e-m:e-i64:64-n32:64-S128-v64:64:64-v128:64:64-v256:64:64-v512:64:64-v1024:64:64-v2048:64:64-v4096:64:64-v8192:64:64-v16384:64:64"
target triple = "ve-unknown-linux-gnu"

; Function Attrs: nounwind
define dso_local void @vfnmsbd_vsvvl(double* %0, double %1, double* %2, double* %3, i32 signext %4) local_unnamed_addr #0 {
; CHECK: vfnmsb.d %v0, %s1, %v0, %v1
  %6 = icmp sgt i32 %4, 0
  br i1 %6, label %8, label %7

7:                                                ; preds = %8, %5
  ret void

8:                                                ; preds = %5, %8
  %9 = phi double* [ %22, %8 ], [ %0, %5 ]
  %10 = phi double* [ %23, %8 ], [ %2, %5 ]
  %11 = phi double* [ %24, %8 ], [ %3, %5 ]
  %12 = phi i32 [ %25, %8 ], [ 0, %5 ]
  %13 = sub nsw i32 %4, %12
  %14 = icmp slt i32 %13, 256
  %15 = select i1 %14, i32 %13, i32 256
  %16 = bitcast double* %10 to i8*
  %17 = tail call <256 x double> @llvm.ve.vl.vld.vssl(i64 8, i8* %16, i32 %15)
  %18 = bitcast double* %11 to i8*
  %19 = tail call <256 x double> @llvm.ve.vl.vld.vssl(i64 8, i8* %18, i32 %15)
  %20 = tail call <256 x double> @llvm.ve.vl.vfnmsbd.vsvvl(double %1, <256 x double> %17, <256 x double> %19, i32 %15)
  %21 = bitcast double* %9 to i8*
  tail call void @llvm.ve.vl.vst.vssl(<256 x double> %20, i64 8, i8* %21, i32 %15)
  %22 = getelementptr inbounds double, double* %9, i64 256
  %23 = getelementptr inbounds double, double* %10, i64 256
  %24 = getelementptr inbounds double, double* %11, i64 256
  %25 = add nuw nsw i32 %12, 256
  %26 = icmp slt i32 %25, %4
  br i1 %26, label %8, label %7
}

; Function Attrs: nounwind readonly
declare <256 x double> @llvm.ve.vl.vld.vssl(i64, i8*, i32) #1

; Function Attrs: nounwind readnone
declare <256 x double> @llvm.ve.vl.vfnmsbd.vsvvl(double, <256 x double>, <256 x double>, i32) #2

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
