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
 
 /Users/qyizhong/Desktop/Kaleidoscope/Examples/average.k
 /Users/qyizhong/Desktop/Kaleidoscope/Examples/fibi.k
 /Users/qyizhong/Desktop/Kaleidoscope/Examples/test.k
 
 */

let isUseJIT = false

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
    //初始化Module和中间代码优化器
    initModule()
    //解析器
    let parser = Parser()
    
    if let path = String(data: FileHandle.standardInput.availableData, encoding: .utf8) {
        if let str = readFile(path) {
            parser.parse(str)
            theModule.targetTriple = .default
            do {
                //这个初始化方法里已经调用了initializeLLVM()
                let targetMachine = try TargetMachine(triple: .default,
                                                      cpu: "x86-64",
                                                      features: "",
                                                      optLevel: .default,
                                                      relocations: .default,
                                                      codeModel: .default)
                theModule.dataLayout = targetMachine.dataLayout
                let pass = PassPipeliner(module: theModule)
                pass.execute()
                if isUseJIT {
                    let runner = CodeRunner(machine: targetMachine)
                    runner.run(module: theModule)
                } else {
                    //修改为自己的路径
                    let path = "/Users/qyizhong/Desktop/Kaleidoscope/Output/output.o"
                    try targetMachine.emitToFile(module: theModule, type: .object, path: path)
                    print("Wrote \(path)")
                }
            } catch {
                print("\(error)")
            }
        }
    }
}

main()
