;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.

;; RUN: foreach %s %t wasm-opt --inlining-optimizing --optimize-level=3 --skip-pass=coalesce-locals -S -o - 2>&1 | filecheck %s

;; We should skip coalese-locals when it is run as an internal sub-pass. Here
;; we inline and optimize afterwards, which normally runs the full set of
;; function passes, but skip pass skips it even there.

(module
 ;; CHECK:      (import "a" "b" (func $log (param i32 i32)))
 (import "a" "b" (func $log (param i32 i32)))

 (func $foo (param $p i32)
  ;; The locals $x and $y can be coalesced into a single local, but as we do not
  ;; run that pass, they will not be. Other minor optimizations will occur here,
  ;; such as using a tee.
  (local $x i32)
  (local $y i32)

  (local.set $x
   (i32.add
    (local.get $p)
    (i32.const 1)
   )
  )
  (call $log
   (local.get $x)
   (local.get $x)
  )

  (local.set $y
   (i32.add
    (local.get $p)
    (i32.const 1)
   )
  )
  (call $log
   (local.get $y)
   (local.get $y)
  )
 )

 ;; CHECK:      (func $call-foo (param $p i32)
 ;; CHECK-NEXT:  (local $1 i32)
 ;; CHECK-NEXT:  (local $2 i32)
 ;; CHECK-NEXT:  (call $log
 ;; CHECK-NEXT:   (local.tee $2
 ;; CHECK-NEXT:    (local.tee $1
 ;; CHECK-NEXT:     (i32.add
 ;; CHECK-NEXT:      (local.get $p)
 ;; CHECK-NEXT:      (i32.const 1)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (local.get $2)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $log
 ;; CHECK-NEXT:   (local.get $1)
 ;; CHECK-NEXT:   (local.get $1)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $call-foo (export "call-foo") (param $p i32)
  (call $foo
   (local.get $p)
  )
 )
)
