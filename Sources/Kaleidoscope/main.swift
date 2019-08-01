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
 
 JIT测试用例:
 def testfunc(x y) x + y*2;
 testfunc(4, 10);
 testfunc(4, 20);
 
 控制语句测试用例:
 extern foo();
 extern bar();
 def baz(x) if x then foo() else bar();
 
 for循环测试用用例:
 extern putchard(char);
 def printstar(n) for i = 1, i < n, 1 in putchard(42);
 
 控制语句和循环语句需要了解的知识点: SSA和Phi
 
 */

func main() {
    //初始化JIT
    theJIT = JIT(machine: targetMachine)
    //初始化Module和中间代码优化器
    initModuleAndPassPipeliner()
    
    while let str = String(data: FileHandle.standardInput.availableData, encoding: .utf8) {
        guard !str.hasPrefix("#") else {
            break
        }
        content = Array(str)
        getNextToken()
        mainLoop()
    }
}

main()
