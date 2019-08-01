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
 
 用户定义一元表达式测试用例:
 def unary ! (v) if v then 0 else 1;
 
 用户定义二元表达式测试用例:
 def binary > 10 (LHS RHS) RHS < LHS;
 
 def testfunc(x y) x + y*2;
 def binary : 1 (x y) 0;
 testfunc(1, 2) : testfunc(3, 4) : testfunc(5, 6);
 
 /Users/qyizhong/Desktop/Kaleidoscope/Examples/test.k
 
 */

func readFile(_ path: String) -> String? {
    var path = path
    if path.hasSuffix("\n") {
        path.removeLast()
    }
    guard path.split(separator: ".").last! == "k" else {
        print("Expected file is *.k.")
        return nil
    }
    do {
        return try String(contentsOfFile: path, encoding: .utf8)
    } catch {
        print("Read file \(path) failure.")
        return nil
    }
}

func main() {
    //初始化JIT
    theJIT = JIT(machine: targetMachine)
    //初始化Module和中间代码优化器
    initModuleAndPassPipeliner()
    
    if let path = String(data: FileHandle.standardInput.availableData, encoding: .utf8) {
        
        if let str = readFile(path) {
            mainLoop(str)
        }
    }
}

main()
