//
//  CallExprAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/27.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//  用于保存函数名

import Foundation

class CallExprAST: ExprAST {
    
    var callee: String?
    
    var args: [ExprAST]?
    
    init(_ callee: String, _ args: [ExprAST]) {
        self.callee = callee
        self.args = args
    }
    
}
