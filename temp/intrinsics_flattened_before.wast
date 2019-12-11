 (func $_ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E (; 19 ;) (type $0) (param $var$0 i64) (param $var$1 i64) (result i64)
  (local $var$2 i32)
  (local $var$3 i32)
  (local $var$4 i32)
  (local $var$5 i64)
  (local $var$6 i64)
  (local $var$7 i64)
  (local $var$8 i64)
  (local $9 i64)
  (local $10 i64)
  (local $11 i32)
  (local $12 i32)
  (local $13 i64)
  (local $14 i32)
  (local $15 i32)
  (local $16 i32)
  (local $17 i64)
  (local $18 i64)
  (local $19 i32)
  (local $20 i32)
  (local $21 i32)
  (local $22 i32)
  (local $23 i32)
  (local $24 i32)
  (local $25 i32)
  (local $26 i32)
  (local $27 i32)
  (local $28 i32)
  (local $29 i64)
  (local $30 i32)
  (local $31 i64)
  (local $32 i32)
  (local $33 i32)
  (local $34 i32)
  (local $35 i64)
  (local $36 i32)
  (local $37 i32)
  (local $38 i32)
  (local $39 i32)
  (local $40 i32)
  (local $41 i32)
  (local $42 i32)
  (local $43 i64)
  (local $44 i32)
  (local $45 i64)
  (local $46 i64)
  (local $47 i64)
  (local $48 i32)
  (local $49 i64)
  (local $50 i32)
  (local $51 i32)
  (local $52 i32)
  (local $53 i32)
  (local $54 i32)
  (local $55 i32)
  (local $56 i32)
  (local $57 i32)
  (local $58 i32)
  (local $59 i32)
  (local $60 i32)
  (local $61 i32)
  (local $62 i64)
  (local $63 i64)
  (local $64 i64)
  (local $65 i64)
  (local $66 i64)
  (local $67 i32)
  (local $68 i32)
  (local $69 i32)
  (local $70 i32)
  (local $71 i32)
  (local $72 i64)
  (local $73 i32)
  (local $74 i32)
  (local $75 i32)
  (local $76 i32)
  (local $77 i32)
  (local $78 i32)
  (local $79 i32)
  (local $80 i32)
  (local $81 i32)
  (local $82 i32)
  (local $83 i32)
  (local $84 i32)
  (local $85 i32)
  (local $86 i32)
  (local $87 i32)
  (local $88 i32)
  (local $89 i32)
  (local $90 i32)
  (local $91 i32)
  (local $92 i32)
  (local $93 i32)
  (local $94 i32)
  (local $95 i32)
  (local $96 i32)
  (local $97 i32)
  (local $98 i32)
  (local $99 i64)
  (local $100 i64)
  (local $101 i32)
  (local $102 i64)
  (local $103 i32)
  (local $104 i32)
  (local $105 i32)
  (local $106 i32)
  (local $107 i32)
  (local $108 i32)
  (local $109 i32)
  (local $110 i32)
  (local $111 i64)
  (local $112 i32)
  (local $113 i32)
  (local $114 i64)
  (local $115 i32)
  (local $116 i32)
  (local $117 i64)
  (local $118 i32)
  (local $119 i32)
  (local $120 i64)
  (local $121 i64)
  (local $122 i32)
  (local $123 i32)
  (local $124 i32)
  (local $125 i32)
  (local $126 i64)
  (local $127 i32)
  (local $128 i32)
  (local $129 i64)
  (local $130 i64)
  (local $131 i64)
  (local $132 i32)
  (local $133 i32)
  (local $134 i64)
  (local $135 i64)
  (local $136 i32)
  (local $137 i64)
  (local $138 i64)
  (local $139 i64)
  (local $140 i64)
  (local $141 i64)
  (local $142 i64)
  (local $143 i64)
  (local $144 i64)
  (local $145 i64)
  (local $146 i64)
  (local $147 i64)
  (local $148 i64)
  (local $149 i64)
  (local $150 i64)
  (local $151 i64)
  (local $152 i64)
  (local $153 i64)
  (local $154 i64)
  (local $155 i64)
  (local $156 i64)
  (local $157 i64)
  (local $158 i64)
  (local $159 i64)
  (local $160 i32)
  (local $161 i32)
  (local $162 i32)
  (local $163 i64)
  (local $164 i64)
  (local $165 i64)
  (local $166 i64)
  (local $167 i64)
  (local $168 i64)
  (local $169 i64)
  (local $170 i64)
  (local $171 i64)
  (block
   (block $label$1
    (block $label$2
     (block $label$3
      (block $label$4
       (block $label$5
        (block $label$6
         (block $label$7
          (block $label$8
           (block $label$9
            (block $label$10
             (block $label$11
              (block
               (local.set $9
                (local.get $var$0)
               )
               (local.set $10
                (i64.shr_u
                 (local.get $9)
                 (i64.const 32)
                )
               )
               (local.set $11
                (i32.wrap_i64
                 (local.get $10)
                )
               )
               (local.set $var$2
                (local.get $11)
               )
               (local.set $12
                (local.get $var$2)
               )
               (if
                (local.get $12)
                (block
                 (block $block
                  (local.set $13
                   (local.get $var$1)
                  )
                  (local.set $14
                   (i32.wrap_i64
                    (local.get $13)
                   )
                  )
                  (local.set $var$3
                   (local.get $14)
                  )
                  (local.set $15
                   (local.get $var$3)
                  )
                  (local.set $16
                   (i32.eqz
                    (local.get $15)
                   )
                  )
                  (br_if $label$11
                   (local.get $16)
                  )
                  (nop)
                  (local.set $17
                   (local.get $var$1)
                  )
                  (local.set $18
                   (i64.shr_u
                    (local.get $17)
                    (i64.const 32)
                   )
                  )
                  (local.set $19
                   (i32.wrap_i64
                    (local.get $18)
                   )
                  )
                  (local.set $var$4
                   (local.get $19)
                  )
                  (local.set $20
                   (local.get $var$4)
                  )
                  (local.set $21
                   (i32.eqz
                    (local.get $20)
                   )
                  )
                  (br_if $label$9
                   (local.get $21)
                  )
                  (nop)
                  (local.set $22
                   (local.get $var$4)
                  )
                  (local.set $23
                   (i32.clz
                    (local.get $22)
                   )
                  )
                  (local.set $24
                   (local.get $var$2)
                  )
                  (local.set $25
                   (i32.clz
                    (local.get $24)
                   )
                  )
                  (local.set $26
                   (i32.sub
                    (local.get $23)
                    (local.get $25)
                   )
                  )
                  (local.set $var$2
                   (local.get $26)
                  )
                  (local.set $27
                   (local.get $var$2)
                  )
                  (local.set $28
                   (i32.le_u
                    (local.get $27)
                    (i32.const 31)
                   )
                  )
                  (br_if $label$8
                   (local.get $28)
                  )
                  (nop)
                  (br $label$2)
                  (unreachable)
                 )
                 (unreachable)
                )
               )
              )
              (nop)
              (local.set $29
               (local.get $var$1)
              )
              (local.set $30
               (i64.ge_u
                (local.get $29)
                (i64.const 4294967296)
               )
              )
              (br_if $label$2
               (local.get $30)
              )
              (nop)
              (local.set $31
               (local.get $var$0)
              )
              (local.set $32
               (i32.wrap_i64     first tee's value to var2
                (local.get $31)
               )
              )
              (local.set $var$2  var2 first tee's set
               (local.get $32)
              )
              (local.set $33
               (local.get $var$2)  var2 first tee's get
              )
              (local.set $34
               (local.get $var$2)
              )
              (local.set $35
               (local.get $var$1)
              )
              (local.set $36
               (i32.wrap_i64     tee's value to var3
                (local.get $35)
               )
              )
              (local.set $var$3
               (local.get $36)
              )
              (local.set $37
               (local.get $var$3)
              )
              (local.set $38
               (i32.div_u        second tee's value to var2
                (local.get $34)
                (local.get $37)
               )
              )
              (local.set $var$2  var2 second tee's set
               (local.get $38)
              )
              (local.set $39
               (local.get $var$2)  var2 second tee's get
              )
              (local.set $40
               (local.get $var$3)
              )
              (local.set $41
               (i32.mul
                (local.get $39)
                (local.get $40)
               )
              )
              (local.set $42
               (i32.sub
                (local.get $33)  var0?
                (local.get $41)
               )
              )
              (local.set $43
               (i64.extend_i32_u
                (local.get $42)
               )
              )
              (call $wasm2js_scratch_store_i64
               (local.get $43)
              )



