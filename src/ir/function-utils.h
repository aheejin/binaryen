/*
 * Copyright 2018 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef wasm_ir_function_h
#define wasm_ir_function_h

#include "ir/utils.h"
#include "wasm.h"

namespace wasm::FunctionUtils {

// Checks if two functions are equal in all functional aspects,
// everything but their name (which can't be the same, in the same
// module!) - same params, vars, body, result, etc.
inline bool equal(Function* left, Function* right) {
  if (left->type != right->type) {
    return false;
  }
  if (left->getNumVars() != right->getNumVars()) {
    return false;
  }
  for (Index i = left->getParams().size(); i < left->getNumLocals(); i++) {
    if (left->getLocalType(i) != right->getLocalType(i)) {
      return false;
    }
  }
  // We could in principle compare metadata here, but intentionally do not, as
  // for optimization purposes we do want to e.g. merge functions that differ
  // only in metadata (following LLVM's example). If we have a non-optimization
  // reason for comparing metadata here then we could add a flag for it.
  if (left->imported() && right->imported()) {
    return true;
  }
  if (left->imported() || right->imported()) {
    return false;
  }
  return ExpressionAnalyzer::equal(left->body, right->body);
}

} // namespace wasm::FunctionUtils

#endif // wasm_ir_function_h
