//
//  UnaryExprAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/8/1.
//

import Foundation

class UnaryExprAST: ExprAST {
    
    let op: String
    
    let operand: ExprAST
    
    init(_ op: String, _ operand: ExprAST) {
        self.op = op
        self.operand = operand
    }
    
    func codeGen() -> IRValue? {
        let operandVal = operand.codeGen()
        guard operandVal != nil else {
            return nil
        }
        let fn = getFunction(named: "unary" + op)
        guard fn != nil else {
            fatalError("Unknow unary operator.")
        }
        return builder.buildCall(fn!, args: [operandVal!], name: "unaryOp")
    }
    
}
