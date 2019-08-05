//
//  CodeRunner.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/8/5.
//

import Foundation
import LLVM

class CodeRunner {
    
    private let jit: JIT
    
    private typealias fnPr = @convention(c) () -> Double
    
    init(machine: TargetMachine) {
        jit = JIT(machine: machine)
    }
    
    public func run(module: Module) {
        do {
            let handle = try jit.addEagerlyCompiledIR(module, { (_) -> JIT.TargetAddress in
                return JIT.TargetAddress()
            })
            let addr = try jit.address(of: "__anon_expr")
            let fn = unsafeBitCast(addr, to: fnPr.self)
            print("\(fn())")
            try jit.removeModule(handle)
        } catch {
            fatalError("Adds the IR from a given module failure.")
        }
    }
    
}
