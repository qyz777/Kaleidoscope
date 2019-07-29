//
//  main.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/27.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//

import Foundation
@_exported import LLVM

/**
 
 测试用例:
 def foo(x y) x+foo(y, 4);
 def foo(x y) x+y y;
 def foo(x y) x+y );
 extern sin(a);
 
 */

while let str = String(data: FileHandle.standardInput.availableData, encoding: .utf8) {
    guard !str.hasPrefix("#") else {
        break
    }
    content = Array(str)
    getNextToken()
    setupPassPipeliner()
    mainLoop()
}
