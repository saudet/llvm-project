; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=ve-unknown-unknown -mattr=+packed | FileCheck %s

;; 256 elements
define fastcc <256 x i32> @vec_fptosi_v256f64_v256i64(<256 x double> %x) {
; CHECK-LABEL: vec_fptosi_v256f64_v256i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vcvt.w.d.sx.rz %v0, %v0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = fptosi <256 x double> %x to <256 x i32>
  ret <256 x i32> %r
}

define fastcc <256 x i32> @vec_fptoui_v256f64_v256i64(<256 x double> %x) {
; CHECK-LABEL: vec_fptoui_v256f64_v256i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vcvt.l.d.rz %v0, %v0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = fptoui <256 x double> %x to <256 x i32>
  ret <256 x i32> %r
}

define fastcc <256 x i64> @vec_fptosi_v256f32_v256i32(<256 x float> %x) {
; CHECK-LABEL: vec_fptosi_v256f32_v256i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vcvt.d.s %v0, %v0
; CHECK-NEXT:    vcvt.l.d.rz %v0, %v0
; CHECK-NEXT:    vcvt.d.l %v0, %v0
; CHECK-NEXT:    vcvt.s.d %v0, %v0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = fptosi <256 x float> %x to <256 x i64>
  ret <256 x i64> %r
}

define fastcc <256 x i64> @vec_fptoui_v256f32_v256i32(<256 x float> %x) {
; CHECK-LABEL: vec_fptoui_v256f32_v256i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea.sl %s0, 1593835520
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vbrd %v1, %s0
; CHECK-NEXT:    pvfsub.up %v2, %v0, %v1
; CHECK-NEXT:    vcvt.d.s %v2, %v2
; CHECK-NEXT:    vcvt.l.d.rz %v2, %v2
; CHECK-NEXT:    vcvt.d.l %v2, %v2
; CHECK-NEXT:    vcvt.s.d %v2, %v2
; CHECK-NEXT:    lea.sl %s0, -2147483648
; CHECK-NEXT:    vxor %v2, %s0, %v2
; CHECK-NEXT:    vfcmp.s %v1, %v0, %v1
; CHECK-NEXT:    vfmk.s.lt %vm1, %v1
; CHECK-NEXT:    vcvt.d.s %v0, %v0, %vm1
; CHECK-NEXT:    vcvt.l.d.rz %v0, %v0, %vm1
; CHECK-NEXT:    b.l.t (, %s10)
  %r = fptoui <256 x float> %x to <256 x i64>
  ret <256 x i64> %r
}

;; 512 elements

define fastcc <512 x i64> @vec_fptosi_v512f64_v512i64(<512 x double> %x) {
; CHECK-LABEL: vec_fptosi_v512f64_v512i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vcvt.l.d.rz %v1, %v1
; CHECK-NEXT:    vcvt.l.d.rz %v0, %v0
; CHECK-NEXT:    # kill: def $v0 killed $v0 def $vp0 killed $v1
; CHECK-NEXT:    b.l.t (, %s10)
  %r = fptosi <512 x double> %x to <512 x i64>
  ret <512 x i64> %r
}

define fastcc <512 x i64> @vec_fptoui_v512f64_v512i64(<512 x double> %x) {
; CHECK-LABEL: vec_fptoui_v512f64_v512i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lea.sl %s1, 1138753536
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vbrd %v3, %s1
; CHECK-NEXT:    vfcmp.d %v2, %v0, %v3
; CHECK-NEXT:    vfmk.l.lt %vm2, %v2
; CHECK-NEXT:    vfcmp.d %v2, %v1, %v3
; CHECK-NEXT:    vfmk.l.lt %vm3, %v2
; CHECK-NEXT:    vfsub.d %v2, %v1, %v3
; CHECK-NEXT:    vcvt.l.d.rz %v2, %v2
; CHECK-NEXT:    lea.sl %s1, -2147483648
; CHECK-NEXT:    vxor %v2, %s1, %v2
; CHECK-NEXT:    vcvt.l.d.rz %v2, %v1, %vm3
; CHECK-NEXT:    vfsub.d %v1, %v0, %v3
; CHECK-NEXT:    vcvt.l.d.rz %v1, %v1
; CHECK-NEXT:    vxor %v3, %s1, %v1
; CHECK-NEXT:    vcvt.l.d.rz %v3, %v0, %vm2
; CHECK-NEXT:    lea %s16, 256
; CHECK-NEXT:    lvl %s16
; CHECK-NEXT:    vor %v1, (0)1, %v2
; CHECK-NEXT:    lea %s16, 256
; CHECK-NEXT:    lvl %s16
; CHECK-NEXT:    vor %v0, (0)1, %v3
; CHECK-NEXT:    b.l.t (, %s10)
  %r = fptoui <512 x double> %x to <512 x i64>
  ret <512 x i64> %r
}

define fastcc <512 x i32> @vec_fptosi_v512f32_v512i32(<512 x float> %x) {
; CHECK-LABEL: vec_fptosi_v512f32_v512i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    pvcvt.w.s.rz %v0, %v0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = fptosi <512 x float> %x to <512 x i32>
  ret <512 x i32> %r
}

define fastcc <512 x i32> @vec_fptoui_v512f32_v512i32(<512 x float> %x) {
; CHECK-LABEL: vec_fptoui_v512f32_v512i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vcvt.d.s %v2, %v0
; CHECK-NEXT:    vcvt.l.d.rz %v2, %v2
; CHECK-NEXT:    vcvt.d.l %v2, %v0
; CHECK-NEXT:    vcvt.s.d %v2, %v2
; CHECK-NEXT:    vshf %v0, %v0, %v0, 4
; CHECK-NEXT:    vcvt.d.s %v3, %v0
; CHECK-NEXT:    vcvt.l.d.rz %v3, %v3
; CHECK-NEXT:    vcvt.d.l %v3, %v0
; CHECK-NEXT:    vcvt.s.d %v3, %v3
; CHECK-NEXT:    vshf %v0, %v3, %v2, 13
; CHECK-NEXT:    b.l.t (, %s10)
  %r = fptoui <512 x float> %x to <512 x i32>
  ret <512 x i32> %r
}
