//
//  IRGen.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/28.
//

import Foundation
import LLVM

let theModule = Module(name: "main")
let globalContext = Context.global
let builder = IRBuilder(module: theModule)
var namedValues: [String: IRValue] = [:]
