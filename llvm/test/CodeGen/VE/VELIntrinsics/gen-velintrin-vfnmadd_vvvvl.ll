; RUN: llc < %s -mtriple=ve-unknown-unknown -mattr=+packed | FileCheck %s
; ModuleID = 'gen/tests/vfnmadd_vvvvl.c'
source_filename = "gen/tests/vfnmadd_vvvvl.c"
target datalayout = "e-m:e-i64:64-n32:64-S128-v64:64:64-v128:64:64-v256:64:64-v512:64:64-v1024:64:64-v2048:64:64-v4096:64:64-v8192:64:64-v16384:64:64"
target triple = "ve-unknown-linux-gnu"

; Function Attrs: nounwind
define dso_local void @vfnmadd_vvvvl(double* %0, double* %1, double* %2, double* %3, i32 signext %4) local_unnamed_addr #0 {
; CHECK: vfnmad.d %v0, %v0, %v1, %v2
  %6 = icmp sgt i32 %4, 0
  br i1 %6, label %8, label %7

7:                                                ; preds = %8, %5
  ret void

8:                                                ; preds = %5, %8
  %9 = phi double* [ %25, %8 ], [ %0, %5 ]
  %10 = phi double* [ %26, %8 ], [ %1, %5 ]
  %11 = phi double* [ %27, %8 ], [ %2, %5 ]
  %12 = phi double* [ %28, %8 ], [ %3, %5 ]
  %13 = phi i32 [ %29, %8 ], [ 0, %5 ]
  %14 = sub nsw i32 %4, %13
  %15 = icmp slt i32 %14, 256
  %16 = select i1 %15, i32 %14, i32 256
  %17 = bitcast double* %10 to i8*
  %18 = tail call <256 x double> @llvm.ve.vl.vld.vssl(i64 8, i8* %17, i32 %16)
  %19 = bitcast double* %11 to i8*
  %20 = tail call <256 x double> @llvm.ve.vl.vld.vssl(i64 8, i8* %19, i32 %16)
  %21 = bitcast double* %12 to i8*
  %22 = tail call <256 x double> @llvm.ve.vl.vld.vssl(i64 8, i8* %21, i32 %16)
  %23 = tail call <256 x double> @llvm.ve.vl.vfnmadd.vvvvl(<256 x double> %18, <256 x double> %20, <256 x double> %22, i32 %16)
  %24 = bitcast double* %9 to i8*
  tail call void @llvm.ve.vl.vst.vssl(<256 x double> %23, i64 8, i8* %24, i32 %16)
  %25 = getelementptr inbounds double, double* %9, i64 256
  %26 = getelementptr inbounds double, double* %10, i64 256
  %27 = getelementptr inbounds double, double* %11, i64 256
  %28 = getelementptr inbounds double, double* %12, i64 256
  %29 = add nuw nsw i32 %13, 256
  %30 = icmp slt i32 %29, %4
  br i1 %30, label %8, label %7
}

; Function Attrs: nounwind readonly
declare <256 x double> @llvm.ve.vl.vld.vssl(i64, i8*, i32) #1

; Function Attrs: nounwind readnone
declare <256 x double> @llvm.ve.vl.vfnmadd.vvvvl(<256 x double>, <256 x double>, <256 x double>, i32) #2

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
