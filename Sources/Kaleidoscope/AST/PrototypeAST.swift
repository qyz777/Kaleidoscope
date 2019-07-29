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
    
    func codeGen() -> Function? {
        let ints = Array(repeating: IntType(width: 1), count: args!.count)
        let ft = FunctionType(ints, IntType(width: 1), variadic: false)
        var f: Function? = builder.addFunction(name!, type: ft)
        if f!.name != name {
            f!.eraseFromParent()
            f = theModule.function(named: name!)
            guard f != nil else {
                return nil
            }
            //是否定义基本块，已经定义了就不能往下走了
            guard !f!.isABasicBlock else {
                fatalError("redefinition of function.")
            }
            guard f!.parameterCount == args!.count else {
                fatalError("redefinition of function with different agrs.")
            }
        }
        //设置参数名
        var p = f!.firstParameter
        for i in 0..<args!.count {
            p?.name = args![i]
            namedValues[args![i]] = p
            p = p?.next()
        }
        return f
    }
    
}
