//
//  main.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/27.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//

import Foundation
import LLVM

let module = Module(name: "main")
module.dump()

/**
 
 测试用例:
 def foo(x y) x+foo(y, 4.0);
 def foo(x y) x+y y;
 def foo(x y) x+y );
 extern sin(a);
 
 */

while let str = String(data: FileHandle.standardInput.availableData, encoding: .utf8) {
    guard str != "#" else {
        break
    }
    content = Array(str)
    getNextToken()
    mainLoop()
}
