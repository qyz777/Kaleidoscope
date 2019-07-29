//
//  ExprAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/27.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//

import Foundation

protocol ExprAST {
    
    func codeGen() -> IRValue?
    
}

extension ExprAST {
    
    func codeGen() -> IRValue? {
        return nil
    }
    
}
