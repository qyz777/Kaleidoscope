//
//  IfExprAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/31.
//

import Foundation

class IfExprAST: ExprAST {
    
    var cond: ExprAST!
    
    var then: ExprAST!
    
    var `else`: ExprAST!
    
    init(_ cond: ExprAST, _ then: ExprAST, _ `else`: ExprAST) {
        self.cond = cond
        self.then = then
        self.else = `else`
    }
    
    func codeGen() -> IRValue? {
        var condV = cond.codeGen()
        guard condV != nil else {
            return nil
        }
        condV = builder.buildICmp(condV!, IntType.int64.zero(), .equal, name: "ifCond")
        
        let theFunction = builder.insertBlock?.parent
        guard theFunction != nil else {
            return nil
        }
        
        //为then else merge创建basic block
        let thenBB = theFunction!.appendBasicBlock(named: "then")
        let elseBB = theFunction!.appendBasicBlock(named: "else")
        let mergeBB = theFunction!.appendBasicBlock(named: "merge")
        
        builder.buildCondBr(condition: condV!, then: thenBB, else: elseBB)
        
        builder.positionAtEnd(of: thenBB)
        let thenVal = then.codeGen()
        guard thenVal != nil else {
            return nil
        }
        builder.buildBr(mergeBB)
        
        builder.positionAtEnd(of: elseBB)
        let elseVal = `else`.codeGen()
        guard elseVal != nil else {
            return nil
        }
        builder.buildBr(mergeBB)
        
        builder.positionAtEnd(of: mergeBB)
        let phi = builder.buildPhi(IntType.int64, name: "phi")
        phi.addIncoming([(thenVal!, thenBB), (elseVal!, elseBB)])
        
        return phi
    }
    
}
