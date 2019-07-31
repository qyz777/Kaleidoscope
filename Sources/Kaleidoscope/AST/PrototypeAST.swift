//
//  PrototypeAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/27.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//

import Foundation

class PrototypeAST {
    
    var name: String?
    
    var args: [String]?
    
    init(_ name: String, _ args: [String]) {
        self.name = name
        self.args = args
    }
    
    func codeGen() -> Function {
        let ints = Array(repeating: IntType(width: 64), count: args!.count)
        let ft = FunctionType(ints, IntType(width: 64), variadic: false)
        var f: Function = theModule.addFunction(name!, type: ft)
        f.linkage = .external
        //设置参数名
        var p = f.firstParameter
        for i in 0..<args!.count {
            p?.name = args![i]
            namedValues[args![i]] = p
            p = p?.next()
        }
        return f
    }
    
}
