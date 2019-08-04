//
//  NumberExprAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/27.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//

import Foundation

class NumberExprAST: ExprAST {
    
    let value: Double
    
    init(_ value: Double) {
        self.value = value
    }
    
    func codeGen() -> IRValue? {
        return FloatType.double.constant(value)
    }
    
}
