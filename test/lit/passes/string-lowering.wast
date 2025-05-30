;; This file checks the custom section that --string-lowering adds. The other
;; operations are tested in string-gathering.wast (which is auto-updated, unlike
;; this which is manual).

(module
  (func $consts
    (drop
      (string.const "foo")
    )
    (drop
      (string.const "bar")
    )
    (drop
      (string.const "foo")
    )
    (drop
      (string.const "needs\tescaping\00.'#%\"- .\r\n\\08\0C\0A\0D\09.ꙮ")
    )
    (drop
      ;; GOTHIC LETTER HWAIR: 𐍈 has code point 0x10348 and is \uD800 \uDF48 in UTF-16.
      (string.const "surrogate pair \F0\90\8D\88 ")
    )
    (drop
      (string.const "unpaired high surrogate \ED\A0\80 ")
    )
    (drop
      (string.const "unpaired low surrogate \ED\BD\88 ")
    )
  )
)

;; The custom section should contain foo and bar, and foo only once, and the
;; string with \t should be escaped.
;;
;; RUN: wasm-opt %s --string-lowering -all -S -o - | filecheck %s
;;
;; If we use magic imports, only invalid strings should be present in the JSON.
;;
;; RUN: wasm-opt %s --string-lowering-magic-imports -all -S -o - \
;; RUN:     | filecheck %s --check-prefix=MAGIC
;;
;; If we use magic imports with asserts, we should get an error.
;;
;; RUN: not wasm-opt %s --string-lowering-magic-imports-assert -all -S -o - \
;; RUN:     2>&1 | filecheck %s --check-prefix=ASSERT
;;
;; CHECK: custom section "string.consts", size 167, contents: "[\"bar\",\"foo\",\"needs\\tescaping\\u0000.'#%\\\"- .\\r\\n\\\\08\\f\\n\\r\\t.\\ua66e\",\"surrogate pair \\ud800\\udf48 \",\"unpaired high surrogate \\ud800 \",\"unpaired low surrogate \\udf48 \"]"
;;
;; MAGIC: custom section "string.consts", size 68, contents: "[\"unpaired high surrogate \\ud800 \",\"unpaired low surrogate \\udf48 \"]"
;;
;; ASSERT: Fatal: Cannot lower non-UTF-16 string "unpaired high surrogate \ef\bf\bd "

;; The custom section should parse OK using JSON.parse from node.
;; (Note we run --remove-unused-module-elements to remove externref-using
;; imports, which require a newer version of node.)
;;
;; RUN: wasm-opt %s --string-lowering --remove-unused-module-elements -all -o %t.wasm
;; RUN: node %S/string-lowering.js %t.wasm | filecheck %s --check-prefix=CHECK-JS
;;
;; CHECK-JS: string: ["bar","foo","needs\tescaping\x00.'#%\"- .\r\n\\08\f\n\r\t.\ua66e","surrogate pair \ud800\udf48 ","unpaired high surrogate \ud800 ","unpaired low surrogate \udf48 "]
;;
;; CHECK-JS: JSON: ["bar","foo","needs\tescaping\x00.'#%\"- .\r\n\\08\f\n\r\t.ꙮ","surrogate pair 𐍈 ","unpaired high surrogate \ud800 ","unpaired low surrogate \udf48 "]
