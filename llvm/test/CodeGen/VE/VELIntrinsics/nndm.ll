; RUN: llc < %s -mtriple=ve -mattr=+vpu,+packed | FileCheck %s

;;; Test negate and vm intrinsic instructions
;;;
;;; Note:
;;;   We test NNDM*mm and NNDM*yy instructions.

; Function Attrs: nounwind readnone
define fastcc <256 x i1> @nndm_mmm(<256 x i1> %0, <256 x i1> %1) {
; CHECK-LABEL: nndm_mmm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    nndm %vm1, %vm1, %vm2
; CHECK-NEXT:    b.l.t (, %s10)
  %3 = tail call <256 x i1> @llvm.ve.vl.nndm.mmm(<256 x i1> %0, <256 x i1> %1)
  ret <256 x i1> %3
}

; Function Attrs: nounwind readnone
declare <256 x i1> @llvm.ve.vl.nndm.mmm(<256 x i1>, <256 x i1>)

; Function Attrs: nounwind readnone
define fastcc <512 x i1> @nndm_MMM(<512 x i1> %0, <512 x i1> %1) {
; CHECK-LABEL: nndm_MMM:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $vm4 killed $vm4 killed $vmp2 def $vmp2
; CHECK-NEXT:    # kill: def $vm2 killed $vm2 killed $vmp1 def $vmp1
; CHECK-NEXT:    # kill: def $vm5 killed $vm5 killed $vmp2 def $vmp2
; CHECK-NEXT:    # kill: def $vm3 killed $vm3 killed $vmp1 def $vmp1
; CHECK-NEXT:    nndm %vm2, %vm2, %vm4
; CHECK-NEXT:    nndm %vm3, %vm3, %vm5
; CHECK-NEXT:    b.l.t (, %s10)
  %3 = tail call <512 x i1> @llvm.ve.vl.nndm.MMM(<512 x i1> %0, <512 x i1> %1)
  ret <512 x i1> %3
}

; Function Attrs: nounwind readnone
declare <512 x i1> @llvm.ve.vl.nndm.MMM(<512 x i1>, <512 x i1>)
