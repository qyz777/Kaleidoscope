//
//  IRGen.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/28.
//

import Foundation
import LLVM

var theModule: Module! = Module(name: "main")
var theJIT: JIT!
let targetMachine = try! TargetMachine()
//var theFPM: FunctionPassManager!
let globalContext = Context.global
let builder = IRBuilder(module: theModule)
var namedValues: [String: IRInstruction] = [:]
var functionProtos: [String: PrototypeAST] = [:]

func initModuleAndPassPipeliner() {
    theModule = Module(name: "main")
//    theModule.dataLayout = targetMachine.dataLayout
//    theFPM = FunctionPassManager(module: theModule)
//    theFPM.add(.promoteMemoryToRegister)
//    theFPM.add(.instructionCombining)
//    theFPM.add(.reassociate)
//    theFPM.add(.gvn)
//    theFPM.add(.cfgSimplification)
}

func getFunction(named name: String) -> Function? {
    if let f = theModule.function(named: name) {
        return f
    } else {
        let fi = functionProtos[name]
        guard fi != nil else {
            return nil
        }
        return fi?.codeGen()
    }
}

func createEntryBlockAlloca(function: Function, name: String) -> IRInstruction {
    let instruction = builder.buildAlloca(type: FloatType.double, count: 0, name: name)
    return instruction
}
