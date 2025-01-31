; RUN: llc < %s -mtriple=ve -mattr=+vpu,+packed | FileCheck %s

;;; Test extract intrinsic instructions
;;;
;;; Note:
;;;   We test extract_vm512u and extract_vm512l pseudo instructions.

; Function Attrs: nounwind readnone
define fastcc <256 x i1> @extract_vm512u(<512 x i1> %0) {
; CHECK-LABEL: extract_vm512u:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $vm2 killed $vm2 killed $vmp1 def $vmp1
; CHECK-NEXT:    # kill: def $vm3 killed $vm3 killed $vmp1 def $vmp1
; CHECK-NEXT:    andm %vm1, %vm0, %vm2
; CHECK-NEXT:    b.l.t (, %s10)
  %2 = tail call <256 x i1> @llvm.ve.vl.extract.vm512u(<512 x i1> %0)
  ret <256 x i1> %2
}

; Function Attrs: nounwind readnone
declare <256 x i1> @llvm.ve.vl.extract.vm512u(<512 x i1>)

; Function Attrs: nounwind readnone
define fastcc <256 x i1> @extract_vm512l(<512 x i1> %0) {
; CHECK-LABEL: extract_vm512l:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $vm2 killed $vm2 killed $vmp1 def $vmp1
; CHECK-NEXT:    # kill: def $vm3 killed $vm3 killed $vmp1 def $vmp1
; CHECK-NEXT:    andm %vm1, %vm0, %vm3
; CHECK-NEXT:    b.l.t (, %s10)
  %2 = tail call <256 x i1> @llvm.ve.vl.extract.vm512l(<512 x i1> %0)
  ret <256 x i1> %2
}

; Function Attrs: nounwind readnone
declare <256 x i1> @llvm.ve.vl.extract.vm512l(<512 x i1>)
