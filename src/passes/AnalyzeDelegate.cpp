/*
 * Copyright 2023 WebAssembly Community Group participants
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

//
// try~delegate analyzer.
// Companion doc:
// https://docs.google.com/document/d/14BQcL90coEnR13iJ7nTiADY87yYhJZHhxaFrwh2QE5w/edit?usp=sharing
//

#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "pass.h"
#include "shared-constants.h"
#include "wasm.h"

namespace wasm {

namespace {

struct DelegateInfo {
  unsigned numDelegates = 0;
  // Whether the function has try~delegates targeting the caller
  bool hasCallerTarget = false;
  // Map of <number of throwable insts within a delegate, # of the occurrence>
  std::map<unsigned, unsigned> numThrowablesInDelegate;
  // Map of <target label, # of delegates targeting that label>
  std::map<Name, unsigned> targetLabels;
};

struct Analyzer : public PostWalker<Analyzer> {
  DelegateInfo info;

  void visitTry(Try* curr) {
    if (!curr->isDelegate()) {
      return;
    }
    info.numDelegates++;

    FindAll<Call> calls(curr);
    FindAll<CallIndirect> call_indirects(curr);
    FindAll<CallRef> call_refs(curr);
    FindAll<Throw> throws(curr);
    FindAll<Rethrow> rethrows(curr);
    unsigned numThrowables = calls.list.size() + call_indirects.list.size() +
                             call_refs.list.size() + throws.list.size() +
                             rethrows.list.size();
    info.numThrowablesInDelegate[numThrowables]++;
    info.targetLabels[curr->delegateTarget]++;

    if (curr->delegateTarget == DELEGATE_CALLER_TARGET) {
      info.hasCallerTarget = true;
    }
  }
};

struct AnalyzeDelegate : public Pass {
  bool modifiesBinaryenIR() override { return false; }

  void run(Module* wasm) override {
    unsigned numDelegates = 0;
    unsigned numFuncsWithDelegate = 0;
    unsigned numTargetLabels = 0;
    unsigned numFuncsWithCallerTarget = 0;
    // Code size increase in bytes in case we remove try~delegate and use exnref
    // + br to achieve the same semantics
    unsigned codeSizeIncrease = 0;

    ModuleUtils::ParallelFunctionAnalysis<DelegateInfo> analysis(
      *wasm, [&](Function* func, DelegateInfo& info) {
        if (func->imported()) {
          return;
        }
        Analyzer analyzer;
        analyzer.walk(func->body);
        info = std::move(analyzer.info);
      });

    for (auto& [func, info] : analysis.map) {
      if (info.numDelegates == 0) {
        continue;
      }

      numFuncsWithDelegate++;
      numDelegates += info.numDelegates;
      if (info.hasCallerTarget) {
        numFuncsWithCallerTarget++;
      }
      // # of target label except for DELEGATE_CALLER_TARGET
      unsigned numFuncTargetLabels = info.hasCallerTarget
                                      ? info.targetLabels.size() - 1
                                      : info.targetLabels.size();
      numTargetLabels += numFuncTargetLabels;

      // Code size increase if we remove try~delegate

      // per try~delegate
      // - try~delegate
      //   1 try: 1 byte
      //   1 delegate: 2 bytes
      //   total 3 bytes
      // - exnref + br
      //   1 try: 1 byte
      //   1 catch_all: 1 byte
      //   1 br: 2 bytes
      //   1 end: 1 byte
      //   total 5 bytes
      // Code size increase (if we remove try~delegate): 5 - 3 = 2 bytes
      // (See the companion doc for the details)
      codeSizeIncrease += info.numDelegates * 2;

      if (info.hasCallerTarget) {
        // per function w/ try~delegates targeting the caller
        // - try~delegate: 0 bytes
        // - exnref + br
        //   1 block: 1 byte
        //   1 end: 1 byte
        //   1 return: 1 byte
        //   1 rethrow: 1 byte
        //   total 5 bytes
        // Code size increase (if we remove try~delegate): 5 - 0 = 5 bytes
        codeSizeIncrease += 5;
      }

      // per target label
      // - try~delegate: 0 bytes
      // - exnref + br
      //   2 blocks: 4 bytes
      //   1 br: 2 bytes
      //   2 ends: 2 bytes
      //   1 rethrow: 1 byte
      //   total 9 bytes
      // Code size increase (if we remove try~delegate): 9 - 0 = 9 bytes
      codeSizeIncrease += numFuncTargetLabels * 9;

      /*
      std::cout << "Func: " << func->name << "\n";
      std::cout << "numThrowablesInDelegate:\n";
      for (auto& [numThrowables, count] : info.numThrowablesInDelegate) {
        std::cout << "  " << numThrowables << ": " << count << "\n";
      }
      std::cout << "targetLabels:\n";
      for (auto& [label, count] : info.targetLabels) {
        std::cout << "  " << label << ": " << count << "\n";
      }
      std::cout << "\n";
      */
    }

    std::cout << "# of defined functions = " << analysis.map.size() << "\n";
    std::cout << "# of functions w/ delegate = " << numFuncsWithDelegate
              << "\n";
    std::cout << "# of functions w/ caller target = "
              << numFuncsWithCallerTarget << "\n";
    std::cout << "# of target labels = " << numTargetLabels << "\n";
    std::cout << "# of try~delegates = " << numDelegates << "\n";
    std::cout << "Code size increase (in bytes) = " << codeSizeIncrease << "\n";
  }
};

} // anonymous namespace

Pass* createAnalyzeDelegatePass() { return new AnalyzeDelegate(); }

} // namespace wasm
