;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --heap-store-optimization -all -S -o - \
;; RUN:   | filecheck %s

(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $struct (descriptor $desc (struct (field (mut i32)))))
    (type $struct (sub final (descriptor $desc (struct (field (mut i32))))))
    ;; CHECK:       (type $desc (sub (describes $struct (struct))))
    (type $desc (sub (describes $struct (struct))))
  )

  ;; CHECK:      (import "" "" (func $effect (type $2)))
  (import "" "" (func $effect))

  ;; CHECK:      (func $no-reorder (type $2)
  ;; CHECK-NEXT:  (local $struct (ref $struct))
  ;; CHECK-NEXT:  (local.set $struct
  ;; CHECK-NEXT:   (struct.new_default $struct
  ;; CHECK-NEXT:    (ref.null none)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:   (block $block (result i32)
  ;; CHECK-NEXT:    (call $effect)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $no-reorder
    (local $struct (ref $struct))
    (local.set $struct
      ;; This traps on the null descriptor, so we cannot optimize the struct.set
      ;; into the struct.new (which would call $effect before the trap).
      (struct.new_default $struct
        (ref.null none)
      )
    )
    (struct.set $struct 0
      (local.get $struct)
      (block $block (result i32)
        (call $effect)
        (i32.const 0)
      )
    )
  )

  ;; CHECK:      (func $yes-reorder (type $2)
  ;; CHECK-NEXT:  (local $struct (ref $struct))
  ;; CHECK-NEXT:  (local.set $struct
  ;; CHECK-NEXT:   (struct.new $struct
  ;; CHECK-NEXT:    (block $block (result i32)
  ;; CHECK-NEXT:     (call $effect)
  ;; CHECK-NEXT:     (i32.const 0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (struct.new_default $desc)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $yes-reorder
    (local $struct (ref $struct))
    ;; As above, but now the descriptor does not trap, so we optimize.
    (local.set $struct
      (struct.new_default $struct
        (struct.new $desc)
      )
    )
    (struct.set $struct 0
      (local.get $struct)
      (block $block (result i32)
        (call $effect)
        (i32.const 0)
      )
    )
  )
)
