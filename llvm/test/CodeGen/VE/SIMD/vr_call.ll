; RUN: llc < %s -mtriple=ve -mattr=+simd | FileCheck %s

define x86_regcallcc <256 x i32> @__regcall3__calc1(<256 x i32>, <256 x i32>) {
; CHECK-LABEL: __regcall3__calc1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vadds.w.sx %v0, %v1, %v0
; CHECK-NEXT:    b.l.t (, %s10)
  %3 = add <256 x i32> %1, %0
  ret <256 x i32> %3
}

define <256 x i32> @calc2(<256 x i32>, <256 x i32>) {
; CHECK-LABEL: calc2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lea %s2, 240(, %s11)
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vldl.sx %v0, 4, %s2
; CHECK-NEXT:    lea %s2, 1264(, %s11)
; CHECK-NEXT:    vldl.sx %v1, 4, %s2
; CHECK-NEXT:    vadds.w.sx %v0, %v1, %v0
; CHECK-NEXT:    vstl %v0, 4, %s0
; CHECK-NEXT:    b.l.t (, %s10)
  %3 = add <256 x i32> %1, %0
  ret <256 x i32> %3
}

define x86_regcallcc <256 x i32> @__regcall3__calc3(<256 x i32>, <256 x i32>, <256 x i32>, <256 x i32>, <256 x i32>, <256 x i32>, <256 x i32>, <256 x i32>, <256 x i32>) {
; CHECK-LABEL: __regcall3__calc3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lea %s1, 240(, %s11)
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vldl.sx %v8, 4, %s1
; CHECK-NEXT:    vadds.w.sx %v0, %v1, %v0
; CHECK-NEXT:    vadds.w.sx %v1, %v3, %v2
; CHECK-NEXT:    vadds.w.sx %v2, %v5, %v4
; CHECK-NEXT:    vadds.w.sx %v3, %v7, %v6
; CHECK-NEXT:    vadds.w.sx %v0, %v0, %v8
; CHECK-NEXT:    vadds.w.sx %v1, %v2, %v1
; CHECK-NEXT:    vadds.w.sx %v0, %v0, %v3
; CHECK-NEXT:    vadds.w.sx %v0, %v0, %v1
; CHECK-NEXT:    b.l.t (, %s10)
  %10 = add <256 x i32> %1, %0
  %11 = add <256 x i32> %3, %2
  %12 = add <256 x i32> %5, %4
  %13 = add <256 x i32> %7, %6
  %14 = add <256 x i32> %10, %8
  %15 = add <256 x i32> %12, %11
  %16 = add <256 x i32> %14, %13
  %17 = add <256 x i32> %16, %15
  ret <256 x i32> %17
}

define x86_regcallcc <256 x i32> @__regcall3__calc4(<256 x i32>, <256 x i32>, <256 x i32>) {
; CHECK-LABEL: __regcall3__calc4:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s16, 256
; CHECK-NEXT:    lea %s0, -2048(, %s9)
; CHECK-NEXT:    lvl %s16
; CHECK-NEXT:    vst %v0, 8, %s0 # 2048-byte Folded Spill
; CHECK-NEXT:    lea %s0, __regcall3__calc1@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s12, __regcall3__calc1@hi(, %s0)
; CHECK-NEXT:    lea %s16, 256
; CHECK-NEXT:    lvl %s16
; CHECK-NEXT:    vor %v0, (0)1, %v1
; CHECK-NEXT:    lea %s16, 256
; CHECK-NEXT:    lvl %s16
; CHECK-NEXT:    vor %v1, (0)1, %v2
; CHECK-NEXT:    bsic %s10, (, %s12)
; CHECK-NEXT:    lea %s0, 256
; CHECK:         lea %s1, -2048(, %s9)
; CHECK-NEXT:    lvl %s16
; CHECK-NEXT:    vld %v1, 8, %s1 # 2048-byte Folded Reload
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vadds.w.sx %v0, %v0, %v1
; CHECK-NEXT:    or %s11, 0, %s9
  %4 = tail call x86_regcallcc <256 x i32> @__regcall3__calc1(<256 x i32> %1, <256 x i32> %2)
  %5 = add <256 x i32> %4, %0
  ret <256 x i32> %5
}
