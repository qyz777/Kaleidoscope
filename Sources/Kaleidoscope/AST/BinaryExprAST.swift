//
//  BinaryExprAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/27.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//  用于保存运算符

import Foundation

class BinaryExprAST: ExprAST {
    
    let op: String
    
    let lhs: ExprAST
    
    let rhs: ExprAST
    
    init(_ op: String, _ lhs: ExprAST, _ rhs: ExprAST) {
        self.op = op
        self.lhs = lhs
        self.rhs = rhs
    }
    
    func codeGen() -> IRValue? {
        let l = lhs.codeGen()
        let r = rhs.codeGen()
        guard l != nil && r != nil else {
            return nil
        }
        switch op {
        case "+":
            return builder.buildAdd(l!, r!, name: "add")
        case "-":
            return builder.buildSub(l!, r!, name: "sub")
        case "*":
            return builder.buildMul(l!, r!, name: "mul")
        case "<":
            let newL = builder.buildICmp(l!, r!, .signedLessThan, name: "boolCmp")
            return builder.buildIntCast(of: newL, to: IntType.int64)
        default:
            break
        }
        
        //如果走到这里了，说明这个运算符是用户自己定义的
        let fn = getFunction(named: "binary" + op)
        guard fn != nil else {
            fatalError("\(String(describing: fn)) binary operator not found!")
        }
        let ops = [l!, r!]
        return builder.buildCall(fn!, args: ops, name: "binaryOp")
    }
    
}
