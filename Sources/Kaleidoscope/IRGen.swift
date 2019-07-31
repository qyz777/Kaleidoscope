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
let passPipeliner = PassPipeliner(module: theModule)
let globalContext = Context.global
let builder = IRBuilder(module: theModule)
var namedValues: [String: IRValue] = [:]
var functionProtos: [String: PrototypeAST] = [:]

func initModuleAndPassPipeliner() {
    theModule = Module(name: "main")
    theModule.dataLayout = targetMachine.dataLayout
    passPipeliner.addStandardFunctionPipeline("pass")
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
