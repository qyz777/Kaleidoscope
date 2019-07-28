//
//  BinaryExprAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/27.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//  用于保存运算符

import Foundation

class BinaryExprAST: ExprAST {
    
    var op: String?
    
    var lhs: ExprAST?
    
    var rhs: ExprAST?
    
    init(_ op: String, _ lhs: ExprAST, _ rhs: ExprAST) {
        self.op = op
        self.lhs = lhs
        self.rhs = rhs
    }
    
    
}
