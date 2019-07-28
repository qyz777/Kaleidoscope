//
//  NumberExprAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/27.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//

import Foundation

class NumberExprAST: ExprAST {
    
    var value: Double?
    
    init(_ value: Double) {
        self.value = value
    }
    
}
