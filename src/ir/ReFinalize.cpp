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

#include "ir/utils.h"

namespace wasm {

static Type getValueType(Expression* value) {
  return value ? value->type : Type::none;
}

void ReFinalize::visitBlock(Block* curr) {
  if (curr->list.size() == 0) {
    curr->type = Type::none;
    return;
  }
  if (curr->name.is()) {
    auto iter = breakTypes.find(curr->name);
    if (iter != breakTypes.end()) {
      // Set the type to be a supertype of the branch types and the flowed-out
      // type. TODO: calculate proper LUBs to compute a new correct type in this
      // situation.
      auto& types = iter->second;
      types.insert(curr->list.back()->type);
      curr->type = Type::getLeastUpperBound(types);
      return;
    }
  }
  curr->type = curr->list.back()->type;
  if (curr->type == Type::unreachable) {
    return;
  }
  // type is none, but we might be unreachable
  if (curr->type == Type::none) {
    for (auto* child : curr->list) {
      if (child->type == Type::unreachable) {
        curr->type = Type::unreachable;
        break;
      }
    }
  }
}
void ReFinalize::visitIf(If* curr) { curr->finalize(); }
void ReFinalize::visitLoop(Loop* curr) { curr->finalize(); }
void ReFinalize::visitBreak(Break* curr) {
  curr->finalize();
  auto valueType = getValueType(curr->value);
  if (valueType == Type::unreachable ||
      getValueType(curr->condition) == Type::unreachable) {
    replaceUntaken(curr->value, curr->condition);
  } else {
    updateBreakValueType(curr->name, valueType);
  }
}
void ReFinalize::visitSwitch(Switch* curr) {
  curr->finalize();
  auto valueType = getValueType(curr->value);
  if (valueType == Type::unreachable ||
      getValueType(curr->condition) == Type::unreachable) {
    replaceUntaken(curr->value, curr->condition);
  } else {
    for (auto target : curr->targets) {
      updateBreakValueType(target, valueType);
    }
    updateBreakValueType(curr->default_, valueType);
  }
}
void ReFinalize::visitCall(Call* curr) { curr->finalize(); }
void ReFinalize::visitCallIndirect(CallIndirect* curr) { curr->finalize(); }
void ReFinalize::visitLocalGet(LocalGet* curr) { curr->finalize(); }
void ReFinalize::visitLocalSet(LocalSet* curr) { curr->finalize(); }
void ReFinalize::visitGlobalGet(GlobalGet* curr) { curr->finalize(); }
void ReFinalize::visitGlobalSet(GlobalSet* curr) { curr->finalize(); }
void ReFinalize::visitLoad(Load* curr) { curr->finalize(); }
void ReFinalize::visitStore(Store* curr) { curr->finalize(); }
void ReFinalize::visitAtomicRMW(AtomicRMW* curr) { curr->finalize(); }
void ReFinalize::visitAtomicCmpxchg(AtomicCmpxchg* curr) { curr->finalize(); }
void ReFinalize::visitAtomicWait(AtomicWait* curr) { curr->finalize(); }
void ReFinalize::visitAtomicNotify(AtomicNotify* curr) { curr->finalize(); }
void ReFinalize::visitAtomicFence(AtomicFence* curr) { curr->finalize(); }
void ReFinalize::visitPause(Pause* curr) { curr->finalize(); }
void ReFinalize::visitSIMDExtract(SIMDExtract* curr) { curr->finalize(); }
void ReFinalize::visitSIMDReplace(SIMDReplace* curr) { curr->finalize(); }
void ReFinalize::visitSIMDShuffle(SIMDShuffle* curr) { curr->finalize(); }
void ReFinalize::visitSIMDTernary(SIMDTernary* curr) { curr->finalize(); }
void ReFinalize::visitSIMDShift(SIMDShift* curr) { curr->finalize(); }
void ReFinalize::visitSIMDLoad(SIMDLoad* curr) { curr->finalize(); }
void ReFinalize::visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
  curr->finalize();
}
void ReFinalize::visitMemoryInit(MemoryInit* curr) { curr->finalize(); }
void ReFinalize::visitDataDrop(DataDrop* curr) { curr->finalize(); }
void ReFinalize::visitMemoryCopy(MemoryCopy* curr) { curr->finalize(); }
void ReFinalize::visitMemoryFill(MemoryFill* curr) { curr->finalize(); }
void ReFinalize::visitConst(Const* curr) { curr->finalize(); }
void ReFinalize::visitUnary(Unary* curr) { curr->finalize(); }
void ReFinalize::visitBinary(Binary* curr) { curr->finalize(); }
void ReFinalize::visitSelect(Select* curr) { curr->finalize(); }
void ReFinalize::visitDrop(Drop* curr) { curr->finalize(); }
void ReFinalize::visitReturn(Return* curr) { curr->finalize(); }
void ReFinalize::visitMemorySize(MemorySize* curr) { curr->finalize(); }
void ReFinalize::visitMemoryGrow(MemoryGrow* curr) { curr->finalize(); }
void ReFinalize::visitRefNull(RefNull* curr) { curr->finalize(); }
void ReFinalize::visitRefIsNull(RefIsNull* curr) { curr->finalize(); }
void ReFinalize::visitRefFunc(RefFunc* curr) {
  // TODO: should we look up the function and update the type from there? This
  // could handle a change to the function's type, but is also not really what
  // this class has been meant to do.
}
void ReFinalize::visitRefEq(RefEq* curr) { curr->finalize(); }
void ReFinalize::visitTableGet(TableGet* curr) { curr->finalize(); }
void ReFinalize::visitTableSet(TableSet* curr) { curr->finalize(); }
void ReFinalize::visitTableSize(TableSize* curr) { curr->finalize(); }
void ReFinalize::visitTableGrow(TableGrow* curr) { curr->finalize(); }
void ReFinalize::visitTableFill(TableFill* curr) { curr->finalize(); }
void ReFinalize::visitTableCopy(TableCopy* curr) { curr->finalize(); }
void ReFinalize::visitTableInit(TableInit* curr) { curr->finalize(); }
void ReFinalize::visitElemDrop(ElemDrop* curr) { curr->finalize(); }
void ReFinalize::visitTry(Try* curr) { curr->finalize(); }
void ReFinalize::visitTryTable(TryTable* curr) {
  curr->finalize();
  for (size_t i = 0; i < curr->catchDests.size(); i++) {
    updateBreakValueType(curr->catchDests[i], curr->sentTypes[i]);
  }
}
void ReFinalize::visitThrow(Throw* curr) { curr->finalize(); }
void ReFinalize::visitRethrow(Rethrow* curr) { curr->finalize(); }
void ReFinalize::visitThrowRef(ThrowRef* curr) { curr->finalize(); }
void ReFinalize::visitNop(Nop* curr) { curr->finalize(); }
void ReFinalize::visitUnreachable(Unreachable* curr) { curr->finalize(); }
void ReFinalize::visitPop(Pop* curr) { curr->finalize(); }
void ReFinalize::visitTupleMake(TupleMake* curr) { curr->finalize(); }
void ReFinalize::visitTupleExtract(TupleExtract* curr) { curr->finalize(); }
void ReFinalize::visitRefI31(RefI31* curr) { curr->finalize(); }
void ReFinalize::visitI31Get(I31Get* curr) { curr->finalize(); }
void ReFinalize::visitCallRef(CallRef* curr) { curr->finalize(); }
void ReFinalize::visitRefTest(RefTest* curr) { curr->finalize(); }
void ReFinalize::visitRefCast(RefCast* curr) { curr->finalize(); }
void ReFinalize::visitRefGetDesc(RefGetDesc* curr) { curr->finalize(); }
void ReFinalize::visitBrOn(BrOn* curr) {
  curr->finalize();
  if (curr->type == Type::unreachable) {
    replaceUntaken(curr->ref, curr->desc);
  } else {
    updateBreakValueType(curr->name, curr->getSentType());
  }
}
void ReFinalize::visitStructNew(StructNew* curr) { curr->finalize(); }
void ReFinalize::visitStructGet(StructGet* curr) { curr->finalize(); }
void ReFinalize::visitStructSet(StructSet* curr) { curr->finalize(); }
void ReFinalize::visitStructRMW(StructRMW* curr) { curr->finalize(); }
void ReFinalize::visitStructCmpxchg(StructCmpxchg* curr) { curr->finalize(); }
void ReFinalize::visitArrayNew(ArrayNew* curr) { curr->finalize(); }
void ReFinalize::visitArrayNewData(ArrayNewData* curr) { curr->finalize(); }
void ReFinalize::visitArrayNewElem(ArrayNewElem* curr) { curr->finalize(); }
void ReFinalize::visitArrayNewFixed(ArrayNewFixed* curr) { curr->finalize(); }
void ReFinalize::visitArrayGet(ArrayGet* curr) { curr->finalize(); }
void ReFinalize::visitArraySet(ArraySet* curr) { curr->finalize(); }
void ReFinalize::visitArrayLen(ArrayLen* curr) { curr->finalize(); }
void ReFinalize::visitArrayCopy(ArrayCopy* curr) { curr->finalize(); }
void ReFinalize::visitArrayFill(ArrayFill* curr) { curr->finalize(); }
void ReFinalize::visitArrayInitData(ArrayInitData* curr) { curr->finalize(); }
void ReFinalize::visitArrayInitElem(ArrayInitElem* curr) { curr->finalize(); }
void ReFinalize::visitArrayRMW(ArrayRMW* curr) { curr->finalize(); }
void ReFinalize::visitArrayCmpxchg(ArrayCmpxchg* curr) { curr->finalize(); }
void ReFinalize::visitRefAs(RefAs* curr) { curr->finalize(); }
void ReFinalize::visitStringNew(StringNew* curr) { curr->finalize(); }
void ReFinalize::visitStringConst(StringConst* curr) { curr->finalize(); }
void ReFinalize::visitStringMeasure(StringMeasure* curr) { curr->finalize(); }
void ReFinalize::visitStringEncode(StringEncode* curr) { curr->finalize(); }
void ReFinalize::visitStringConcat(StringConcat* curr) { curr->finalize(); }
void ReFinalize::visitStringEq(StringEq* curr) { curr->finalize(); }
void ReFinalize::visitStringTest(StringTest* curr) { curr->finalize(); }
void ReFinalize::visitStringWTF16Get(StringWTF16Get* curr) { curr->finalize(); }
void ReFinalize::visitStringSliceWTF(StringSliceWTF* curr) { curr->finalize(); }
void ReFinalize::visitContNew(ContNew* curr) { curr->finalize(); }
void ReFinalize::visitContBind(ContBind* curr) { curr->finalize(); }
void ReFinalize::visitSuspend(Suspend* curr) { curr->finalize(getModule()); }
void ReFinalize::visitResume(Resume* curr) {
  curr->finalize();
  for (size_t i = 0; i < curr->handlerBlocks.size(); i++) {
    updateBreakValueType(curr->handlerBlocks[i], curr->sentTypes[i]);
  }
}
void ReFinalize::visitResumeThrow(ResumeThrow* curr) {
  curr->finalize();
  for (size_t i = 0; i < curr->handlerBlocks.size(); i++) {
    updateBreakValueType(curr->handlerBlocks[i], curr->sentTypes[i]);
  }
}
void ReFinalize::visitStackSwitch(StackSwitch* curr) { curr->finalize(); }

void ReFinalize::visitExport(Export* curr) { WASM_UNREACHABLE("unimp"); }
void ReFinalize::visitGlobal(Global* curr) { WASM_UNREACHABLE("unimp"); }
void ReFinalize::visitTable(Table* curr) { WASM_UNREACHABLE("unimp"); }
void ReFinalize::visitElementSegment(ElementSegment* curr) {
  WASM_UNREACHABLE("unimp");
}
void ReFinalize::visitMemory(Memory* curr) { WASM_UNREACHABLE("unimp"); }
void ReFinalize::visitDataSegment(DataSegment* curr) {
  WASM_UNREACHABLE("unimp");
}
void ReFinalize::visitTag(Tag* curr) { WASM_UNREACHABLE("unimp"); }
void ReFinalize::visitModule(Module* curr) { WASM_UNREACHABLE("unimp"); }

void ReFinalize::updateBreakValueType(Name name, Type type) {
  if (type != Type::unreachable) {
    breakTypes[name].insert(type);
  }
}

// Replace a branch/switch that is untaken because it is unreachable with an
// unreachable non-branching expression. There is one or both of a value and
// condition/descriptor, at least one of which is unreachable.
void ReFinalize::replaceUntaken(Expression* value, Expression* otherChild) {
  assert((value && value->type == Type::unreachable) ||
         (otherChild && otherChild->type == Type::unreachable));
  Builder builder(*getModule());
  if (value && otherChild) {
    if (value->type.isConcrete()) {
      value = builder.makeDrop(value);
    } else if (otherChild->type.isConcrete()) {
      otherChild = builder.makeDrop(otherChild);
    }
    replaceCurrent(builder.makeBlock({value, otherChild}, Type::unreachable));
  } else if (value) {
    replaceCurrent(value);
  } else {
    assert(otherChild);
    replaceCurrent(otherChild);
  }
}

} // namespace wasm
