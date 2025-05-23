;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.

;; Check that we don't refine in ways that might require invalid exact casts
;; when custom descriptors is disabled.

;; RUN: wasm-opt %s -all                              --closed-world --preserve-type-order \
;; RUN:     --type-refining-gufa -S -o - | filecheck %s

;; RUN: wasm-opt %s -all --disable-custom-descriptors --closed-world --preserve-type-order \
;; RUN:     --type-refining-gufa -S -o - | filecheck %s --check-prefix=NO_CD

(module
  ;; CHECK:      (type $foo (struct))
  ;; NO_CD:      (type $foo (struct))
  (type $foo (struct))
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $bar (struct (field (ref (exact $foo)))))
  ;; NO_CD:      (rec
  ;; NO_CD-NEXT:  (type $bar (struct (field (ref $foo))))
  (type $bar (struct (field (ref null $foo))))

  ;; CHECK:       (type $already-exact (struct (field (ref (exact $foo)))))
  ;; NO_CD:       (type $already-exact (struct (field (ref (exact $foo)))))
  (type $already-exact (struct (field (ref (exact $foo)))))

  ;; CHECK:      (import "" "" (global $exact (ref (exact $foo))))
  ;; NO_CD:      (import "" "" (global $exact (ref (exact $foo))))
  (import "" "" (global $exact (ref (exact $foo))))

  ;; CHECK:      (global $g (ref $foo) (global.get $exact))
  ;; NO_CD:      (global $g (ref $foo) (global.get $exact))
  (global $g (ref $foo) (global.get $exact))

  ;; CHECK:      (func $make-bar (type $3)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $bar
  ;; CHECK-NEXT:    (ref.cast (ref (exact $foo))
  ;; CHECK-NEXT:     (global.get $g)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; NO_CD:      (func $make-bar (type $3)
  ;; NO_CD-NEXT:  (drop
  ;; NO_CD-NEXT:   (struct.new $bar
  ;; NO_CD-NEXT:    (global.get $g)
  ;; NO_CD-NEXT:   )
  ;; NO_CD-NEXT:  )
  ;; NO_CD-NEXT: )
  (func $make-bar
    (drop
      (struct.new $bar
        (global.get $g)
      )
    )
  )

  ;; CHECK:      (func $make-already-exact (type $4) (result (ref (exact $foo)))
  ;; CHECK-NEXT:  (struct.get $already-exact 0
  ;; CHECK-NEXT:   (struct.new $already-exact
  ;; CHECK-NEXT:    (global.get $exact)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; NO_CD:      (func $make-already-exact (type $4) (result (ref (exact $foo)))
  ;; NO_CD-NEXT:  (struct.get $already-exact 0
  ;; NO_CD-NEXT:   (struct.new $already-exact
  ;; NO_CD-NEXT:    (global.get $exact)
  ;; NO_CD-NEXT:   )
  ;; NO_CD-NEXT:  )
  ;; NO_CD-NEXT: )
  (func $make-already-exact (result (ref (exact $foo)))
    ;; We should not accidentally remove exactness from a field that is already exact.
    (struct.get $already-exact 0
      (struct.new $already-exact
        (global.get $exact)
      )
    )
  )
)
