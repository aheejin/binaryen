(module
  (memory 1
    (segment 4 "\10\04\00\00")
  )
  (export "memory" memory)
  (export "immediate_f32" $immediate_f32)
  (export "immediate_f64" $immediate_f64)
  (export "bitcast_i32_f32" $bitcast_i32_f32)
  (export "bitcast_f32_i32" $bitcast_f32_i32)
  (export "bitcast_i64_f64" $bitcast_i64_f64)
  (export "bitcast_f64_i64" $bitcast_f64_i64)
  (func $immediate_f32 (result f32)
    (f32.const 2.5)
  )
  (func $immediate_f64 (result f64)
    (f64.const 2.5)
  )
  (func $bitcast_i32_f32 (param $0 f32) (result i32)
    (i32.reinterpret/f32
      (get_local $0)
    )
  )
  (func $bitcast_f32_i32 (param $0 i32) (result f32)
    (f32.reinterpret/i32
      (get_local $0)
    )
  )
  (func $bitcast_i64_f64 (param $0 f64) (result i64)
    (i64.reinterpret/f64
      (get_local $0)
    )
  )
  (func $bitcast_f64_i64 (param $0 i64) (result f64)
    (f64.reinterpret/i64
      (get_local $0)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
