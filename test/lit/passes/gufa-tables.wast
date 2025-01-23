;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt -all --gufa -S -o - | filecheck %s

;; Non-private tables can contain anything, so we cannot assume anything about
;; the results of a call to them.
(module
 ;; CHECK:      (type $type (func (result f64)))
 (type $type (func (result f64)))

 ;; CHECK:      (type $1 (func))

 ;; CHECK:      (import "a" "b" (table $imported 30 40 funcref))
 (import "a" "b" (table $imported 30 40 funcref))

 ;; CHECK:      (table $exported 10 20 funcref)
 (table $exported 10 20 funcref)

 ;; CHECK:      (table $private 50 60 funcref)
 (table $private  50 60 funcref)

 ;; CHECK:      (export "func" (func $func))

 ;; CHECK:      (export "table" (table $exported))
 (export "table" (table $exported))

 ;; CHECK:      (func $func (type $1)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (call_indirect $exported (type $type)
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (call_indirect $imported (type $type)
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (block
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (call_indirect $private (type $type)
 ;; CHECK-NEXT:      (i32.const 0)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (unreachable)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $func (export "func")
  ;; We cannot optimize anything with the exported or imported table.
  (drop
   (call_indirect $exported (type $type)
    (i32.const 0)
   )
  )
  (drop
   (call_indirect $imported (type $type)
    (i32.const 0)
   )
  )
  ;; We can optimize the private table: this will trap.
  (drop
   (call_indirect $private (type $type)
    (i32.const 0)
   )
  )
 )
)

;; Test a tuple-returning call_indirect. There is nothing to optimize here, but
;; we should not error while marking the call_indirect as returning a tuple of
;; unknown values (unknown, since the table is exported).
(module
 ;; CHECK:      (type $5 (func (result f64 i32)))
 (type $5 (func (result f64 i32)))

 ;; CHECK:      (table $table 44 funcref)
 (table $table 44 funcref)

 ;; CHECK:      (elem $elem (i32.const 0) $make)
 (elem $elem (i32.const 0) $make)

 ;; CHECK:      (export "table" (table $table))
 (export "table" (table $table))

 ;; CHECK:      (func $make (type $5) (result f64 i32)
 ;; CHECK-NEXT:  (tuple.make 2
 ;; CHECK-NEXT:   (f64.const 3.14159)
 ;; CHECK-NEXT:   (i32.const 42)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $make (type $5) (result f64 i32)
  (tuple.make 2
   (f64.const 3.14159)
   (i32.const 42)
  )
 )

 ;; CHECK:      (func $call (type $5) (result f64 i32)
 ;; CHECK-NEXT:  (call_indirect $table (type $5)
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $call (result f64 i32)
  (call_indirect $table (type $5)
   (i32.const 0)
  )
 )
)
