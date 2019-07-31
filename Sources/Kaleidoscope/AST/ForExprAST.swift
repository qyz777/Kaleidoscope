//
//  ForExprAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/31.
//

import Foundation

class ForExprAST: ExprAST {
    
    var name: String!
    
    var start: ExprAST!
    
    var end: ExprAST!
    
    var step: ExprAST!
    
    var body: ExprAST!
    
    init(_ name: String, _ start: ExprAST, _ end: ExprAST, _ step: ExprAST, _ body: ExprAST) {
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
        let preHeaderBB = builder.insertBlock
        let loopBB = theFunction!.appendBasicBlock(named: "loop")
        builder.buildBr(loopBB)
        builder.positionAtEnd(of: loopBB)
        
        //这里控制循环或退出
        let phi = builder.buildPhi(IntType.int64, name: name)
        phi.addIncoming([(startVal!, preHeaderBB!)])
        
        let oldVal = namedValues[name]
        namedValues[name] = phi
        
        guard body.codeGen() != nil else {
            return nil
        }
        
        let stepVal = step.codeGen()
        guard stepVal != nil else {
            return nil
        }
        
        let nextVar = builder.buildAdd(phi, stepVal!, name: "nextVar")
        
        //循环终止条件
        var endCond = end.codeGen()
        guard endCond != nil else {
            return nil
        }
        endCond = builder.buildICmp(endCond!, IntType.int64.zero(), .equal, name: "loopCond")
        
        //循环后的代码basic block
        let loopEndBB = builder.insertBlock
        let afterBB = theFunction?.appendBasicBlock(named: "afterLoop")
        builder.buildCondBr(condition: endCond!, then: loopBB, else: afterBB!)
        builder.positionAtEnd(of: afterBB!)
        
        phi.addIncoming([(nextVar, loopEndBB!)])
        
        if oldVal != nil {
            namedValues[name] = oldVal!
        } else {
            namedValues[name] = nil
        }
        
        //for循环解析总是返回0
        return IntType.int64.zero()
    }
    
}
