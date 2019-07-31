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
        functionProtos[proto!.name!] = proto
        let theFunction = getFunction(named: proto!.name!)
        guard theFunction != nil else {
            return nil
        }
        
        let entry = theFunction!.appendBasicBlock(named: "entry")
        builder.positionAtEnd(of: entry)
        
        namedValues.removeAll()
        var p = theFunction!.firstParameter
        while p != nil {
            namedValues[p!.name] = p!
            p = p?.next()
        }
        
        if let retValue = body!.codeGen() {
            builder.buildRet(retValue)
            do {
                try theModule.verify()
                passPipeliner.execute()
                return theFunction
            } catch {
                print("verify failure: \(error)")
            }
        }
        //函数体出现问题，移除函数
        theFunction!.eraseFromParent()
        return nil
    }
    
}
