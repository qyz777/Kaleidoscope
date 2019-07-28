//
//  PrototypeAST.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/27.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//

import Foundation

class PrototypeAST {
    
    var name: String?
    
    var args: [String]?
    
    init(_ name: String, _ args: [String]) {
        self.name = name
        self.args = args
    }
    
}
