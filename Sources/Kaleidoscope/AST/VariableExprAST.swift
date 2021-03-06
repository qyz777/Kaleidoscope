//
//  VariableExprAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/27.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//  用于保存变量名

import Foundation

class VariableExprAST: ExprAST {
    
    let name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    func codeGen() -> IRValue? {
        let value = namedValues[name]
        guard value != nil else {
            fatalError("unknow variable name.")
        }
        return builder.buildLoad(value!, name: name)
    }
    
}
