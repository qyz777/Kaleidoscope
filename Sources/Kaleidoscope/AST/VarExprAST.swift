//
//  VarExprAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/8/2.
//

import Foundation

class VarExprAST: ExprAST {
    
    let varNames: [(String, ExprAST?)]
    
    let body: ExprAST
    
    init(_ varNames: [(String, ExprAST?)], _ body: ExprAST) {
        self.varNames = varNames
        self.body = body
    }
    
    func codeGen() -> IRValue? {
        var oldBindings: [IRInstruction?] = []
        let theFunction = builder.insertBlock?.parent
        guard theFunction != nil else {
            return nil
        }
        //注册所有变量，并让他们初始化
        for v in varNames {
            let initVal: IRValue?
            if v.1 != nil {
                initVal = v.1?.codeGen()
                guard initVal != nil else {
                    return nil
                }
            } else {
                //没有的话就默认0
                initVal = FloatType.double.constant(0)
            }
            
            let alloca = createEntryBlockAlloca(function: theFunction!, name: v.0)
            //初始化变量，把initVal存到alloca中
            builder.buildStore(initVal!, to: alloca)
            oldBindings.append(namedValues[v.0])
            namedValues[v.0] = alloca
        }
        
        let bodyVal = body.codeGen()
        guard bodyVal != nil else {
            return nil
        }
        //恢复之前的变量绑定
        for i in 0..<varNames.count {
            namedValues[varNames[i].0] = oldBindings[i]
        }
        return bodyVal
    }
    
}
