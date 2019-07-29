//
//  FunctionAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/27.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//

import Foundation

class FunctionAST {
    
    var proto: PrototypeAST?
    
    var body: ExprAST?
    
    init(_ proto: PrototypeAST, _ body: ExprAST) {
        self.proto = proto
        self.body = body
    }
    
    func codeGen() -> Function? {
        namedValues.removeAll()
        let theFunction = proto!.codeGen()
        guard theFunction != nil else {
            return nil
        }
        let bb = BasicBlock(name: "entry")
        builder.positionAtEnd(of: bb)
        if let retValue = body!.codeGen() {
            builder.buildRet(retValue)
            return theFunction
        }
        //函数体出现问题，移除函数
        theFunction!.eraseFromParent()
        return nil
    }
    
}
