//
//  ForExprAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/31.
//

import Foundation

class ForExprAST: ExprAST {
    
    let name: String
    
    let start: ExprAST
    
    let end: ExprAST
    
    let step: ExprAST?
    
    let body: ExprAST
    
    init(_ name: String, _ start: ExprAST, _ end: ExprAST, _ step: ExprAST?, _ body: ExprAST) {
        self.name = name
        self.start = start
        self.end = end
        self.step = step
        self.body = body
    }
    
    func codeGen() -> IRValue? {
        let startVal = start.codeGen()
        guard startVal != nil else {
            return nil
        }
        
        //for循环，插在当前的block之后
        let theFunction = builder.insertBlock?.parent
        guard theFunction != nil else {
            return nil
        }
        
        let alloca = createEntryBlockAlloca(function: theFunction!, name: name)
        builder.buildStore(startVal!, to: alloca)
        
        let loopBB = theFunction!.appendBasicBlock(named: "loop")
        builder.buildBr(loopBB)
        builder.positionAtEnd(of: loopBB)
        
        let oldVal = namedValues[name]
        namedValues[name] = alloca
        
        guard body.codeGen() != nil else {
            return nil
        }
        
        let stepVal: IRValue?
        if step != nil {
            stepVal = step!.codeGen()
            guard stepVal != nil else {
                return nil
            }
        } else {
            stepVal = FloatType.double.constant(1)
        }
        
        //循环终止条件
        var endCond = end.codeGen()
        guard endCond != nil else {
            return nil
        }
        //build条件时候要使用int类型
        endCond = builder.buildICmp(endCond!, IntType.int1.zero(), .equal, name: "loopCond")
        
        let curVal = builder.buildLoad(alloca)
        let nextVal = builder.buildAdd(curVal, startVal!, name: "nextVal")
        builder.buildStore(nextVal, to: alloca)
        
        //循环后的代码basic block
        let afterBB = theFunction?.appendBasicBlock(named: "afterLoop")
        builder.buildCondBr(condition: endCond!, then: loopBB, else: afterBB!)
        builder.positionAtEnd(of: afterBB!)
        
        if oldVal != nil {
            namedValues[name] = oldVal!
        } else {
            namedValues[name] = nil
        }
        
        //for循环解析总是返回0
        return FloatType.double.constant(0)
    }
    
}
