//
//  PrototypeAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/27.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//

import Foundation

enum PrototypeKind: Int {
    case identifier
    case unary
    case binary
}

class PrototypeAST {
    
    let name: String
    
    let args: [String]
    
    let isOperator: Bool
    
    let precedence: UInt
    
    private var isBinaryOp: Bool {
        return isOperator && args.count == 2
    }
    
    private var isUnaryOp: Bool {
        return isOperator && args.count == 1
    }
    
    var operatorName: String? {
        guard isUnaryOp || isOperator else {
            return nil
        }
        return String(Array(name).last!)
    }
    
    init(_ name: String, _ args: [String], _ isOperator: Bool = false, _ precedence: UInt = 0) {
        self.name = name
        self.args = args
        self.isOperator = isOperator
        self.precedence = precedence
    }
    
    func codeGen() -> Function {
        let ints = Array(repeating: FloatType.double, count: args.count)
        let ft = FunctionType(ints, FloatType.double, variadic: false)
        var f: Function = theModule.addFunction(name, type: ft)
        //这其实是默认linkage，这里为了和官方教程保持一致，显示的写一下
        f.linkage = .external
        //设置参数名
        var p = f.firstParameter
        for i in 0..<args.count {
            p?.name = args[i]
            p = p?.next()
        }
        return f
    }
    
}
