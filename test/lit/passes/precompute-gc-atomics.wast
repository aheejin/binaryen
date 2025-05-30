;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.

;; RUN: wasm-opt %s -all --precompute-propagate -S -o - | filecheck %s

(module
  ;; CHECK:      (type $shared (shared (struct (field i32))))
  (type $shared (shared (struct (field i32))))
  ;; CHECK:      (type $unshared (struct (field i32)))
  (type $unshared (struct (field i32)))

  ;; CHECK:      (func $get-unordered-unshared (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT: )
  (func $get-unordered-unshared (result i32)
    (struct.get $unshared 0
      (struct.new_default $unshared)
    )
  )

  ;; CHECK:      (func $get-unordered-shared (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT: )
  (func $get-unordered-shared (result i32)
    (struct.get $shared 0
      (struct.new_default $shared)
    )
  )

  ;; CHECK:      (func $get-seqcst-unshared (type $0) (result i32)
  ;; CHECK-NEXT:  (struct.atomic.get $unshared 0
  ;; CHECK-NEXT:   (struct.new_default $unshared)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $get-seqcst-unshared (result i32)
    (struct.atomic.get seqcst $unshared 0
      (struct.new_default $unshared)
    )
  )

  ;; CHECK:      (func $get-seqcst-shared (type $0) (result i32)
  ;; CHECK-NEXT:  (struct.atomic.get $shared 0
  ;; CHECK-NEXT:   (struct.new_default $shared)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $get-seqcst-shared (result i32)
    (struct.atomic.get seqcst $shared 0
      (struct.new_default $shared)
    )
  )

  ;; CHECK:      (func $get-acqrel-unshared (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT: )
  (func $get-acqrel-unshared (result i32)
    ;; We can optimize this because acquire-release on unshared data does not
    ;; synchronize with anything.
    (struct.atomic.get acqrel $unshared 0
      (struct.new_default $unshared)
    )
  )

  ;; CHECK:      (func $get-acqrel-shared (type $0) (result i32)
  ;; CHECK-NEXT:  (struct.atomic.get acqrel $shared 0
  ;; CHECK-NEXT:   (struct.new_default $shared)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $get-acqrel-shared (result i32)
    (struct.atomic.get acqrel $shared 0
      (struct.new_default $shared)
    )
  )
)
