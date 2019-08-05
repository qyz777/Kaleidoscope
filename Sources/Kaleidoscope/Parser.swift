//
//  Parser.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/28.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//

import Foundation

var BinOpPrecedence: [String: UInt] = ["=": 2, "<": 10, "+": 20, "-": 20, "*": 40]

class Parser {
    
    private let lexer = Lexer()
    
    init() {
        lexer.delegate = self
    }
    
}

extension Parser {
    
    /// 解析代码
    ///
    /// - Parameter sourceInput: 代码数据源
    public func parse(_ sourceInput: String) {
        lexer.start(sourceInput)
    }
    
}

extension Parser: LexerDelegate {
    
    func lexerWithDefinition(_ lexer: Lexer) {
        if let p = parseDefinition() {
            if let f = p.codeGen() {
                print("Read function definition:")
                f.dump()
            }
        } else {
            lexer.nextToken()
        }
    }
    
    func lexerWithExtern(_ lexer: Lexer) {
        let p = parseExtern()
        let f = p.codeGen()
        f.dump()
        functionProtos[p.name] = p
    }
    
    func lexerWithTopLevelExpression(_ lexer: Lexer) {
        if let p = parseTopLevelExpr() {
            if let f = p.codeGen() {
                print("Read top-level expression:")
                f.dump()
            }
        } else {
            lexer.nextToken()
        }
    }
    
}

extension Parser {
    
    /// 解析变量引用和函数调用
    ///
    /// - Returns: AST
    private func parseIdentifierExpr() -> ExprAST? {
        let idName = lexer.currentToken!.val
        lexer.nextToken()
        if lexer.currentToken!.val != "(" {
            return VariableExprAST(idName)
        }
        lexer.nextToken()
        var args: [ExprAST] = []
        if lexer.currentToken!.val != ")" {
            while true {
                let arg = parseExpression()
                guard arg != nil else {
                    return nil
                }
                args.append(arg!)
                if lexer.currentToken!.val == ")" {
                    break
                }
                if lexer.currentToken!.val != "," {
                    fatalError("Expected ')' or ',' in argument list")
                }
                lexer.nextToken()
            }
        }
        
        lexer.nextToken()
        
        return CallExprAST(idName, args)
    }
    
    /// 解析数值常量
    ///
    /// - Returns: AST
    private func parseNumberExpr() -> ExprAST {
        let result = NumberExprAST(Double(lexer.currentToken!.val)!)
        lexer.nextToken()
        return result
    }
    
    /// 解析'('开头的表达式
    ///
    /// - Returns: AST
    func parseParenExpr() -> ExprAST? {
        lexer.nextToken()
        let v = parseExpression()
        guard v != nil else {
            return nil
        }
        if lexer.currentToken!.val != ")" {
            fatalError("Expected '\(lexer.currentToken!.val)'")
        }
        lexer.nextToken()
        return v
    }
    
    /// 解析基本表达式的入口
    ///
    /// - Returns: AST
    private func parsePrimary() -> ExprAST? {
        guard lexer.currentToken != nil else {
            return nil
        }
        if lexer.currentToken!.val == "(" {
            return parseParenExpr()
        }
        switch lexer.currentToken!.token {
        case .identifier:
            return parseIdentifierExpr()
        case .number:
            return parseNumberExpr()
        case .if:
            return parseIfExpr()
        case .for:
            return parseForExpr()
        case .var:
            return parseVarExpr()
        default:
            fatalError("unknow token when expecting an expression")
        }
    }
    
    /// 解析二元运算符
    ///
    /// - Parameters:
    ///   - exprPrec: 二元运算符优先级
    ///   - lhs: 左表达式
    /// - Returns: AST
    private func parseBinOpRHS(_ exprPrec: Int, _ lhs: inout ExprAST) -> ExprAST? {
        while true {
            let tokPrec = getTokenPrecedence()
            if tokPrec < exprPrec {
                return lhs
            }
            
            //获取二元运算符
            let binOp = lexer.currentToken
            lexer.nextToken()
            
            //解析二元运算符右边的表达式
            var rhs = parseUnaryExpr()
            guard rhs != nil else {
                return nil
            }
            
            let nextPrec = getTokenPrecedence()
            if tokPrec < nextPrec {
                rhs = parseBinOpRHS(tokPrec + 1, &rhs!)
                guard rhs != nil else {
                    return nil
                }
            }
            lhs = BinaryExprAST(binOp!.val, lhs, rhs!)
        }
    }
    
    /// 解析表达式
    ///
    /// - Returns: AST
    func parseExpression() -> ExprAST? {
        var lhs = parseUnaryExpr()
        guard lhs != nil else {
            return nil
        }
        return parseBinOpRHS(0, &lhs!)
    }
    
    /// 解析函数原型
    ///
    /// - Returns: 函数原型AST
    func parsePrototype() -> PrototypeAST {
        var fnName: String
        let kind: PrototypeKind
        var binaryPrecedence: UInt = 30
        
        switch lexer.currentToken!.token {
        case .identifier:
            fnName = lexer.currentToken!.val
            kind = .identifier
            lexer.nextToken()
            break
        case .binary:
            lexer.nextToken()
            guard Array(lexer.currentToken!.val)[0].isASCII else {
                fatalError("Expected binary operator.")
            }
            fnName = "binary"
            fnName += lexer.currentToken!.val
            kind = .binary
            lexer.nextToken()
            
            if lexer.currentToken!.token == .number {
                let num = UInt(lexer.currentToken!.val)!
                if num < 1 || num > 100 {
                    fatalError("Invalid precedence: must be 1...100.")
                }
                binaryPrecedence = num
                lexer.nextToken()
            }
            break
        case .unary:
            lexer.nextToken()
            guard Array(lexer.currentToken!.val)[0].isASCII else {
                fatalError("Expected unary operator.")
            }
            fnName = "unary"
            fnName += lexer.currentToken!.val
            kind = .unary
            lexer.nextToken()
            break
        default:
            fatalError("Expected function name in prototype.")
        }
        
        if lexer.currentToken!.val != "(" {
            fatalError("Expected '(' in prototype")
        }
        
        lexer.nextToken()
        var argNames: [String] = []
        while lexer.currentToken!.token == .identifier {
            argNames.append(lexer.currentToken!.val)
            lexer.nextToken()
        }
        if lexer.currentToken!.val != ")" {
            fatalError("Expected ')' in prototype")
        }
        lexer.nextToken()
        
        if kind != .identifier && kind.rawValue != argNames.count {
            fatalError("Invalid number of operands for operator.")
        }
        
        return PrototypeAST(fnName, argNames, kind.rawValue != 0, binaryPrecedence)
    }
    
    /// 解析函数定义
    ///
    /// - Returns: 函数定义AST
    private func parseDefinition() -> FunctionAST? {
        lexer.nextToken()
        let proto = parsePrototype()
        if let e = parseExpression() {
            return FunctionAST(proto, e)
        }
        return nil
    }
    
    /// 解析extern导出定义
    ///
    /// - Returns: 原型AST
    private func parseExtern() -> PrototypeAST {
        lexer.nextToken()
        return parsePrototype()
    }
    
    /// 解析顶级表达式
    ///
    /// - Returns: 函数AST
    private func parseTopLevelExpr() -> FunctionAST? {
        if let e = parseExpression() {
            //__anon_expr为默认占位函数名
            let proto = PrototypeAST("__anon_expr", [])
            return FunctionAST(proto, e)
        }
        return nil
    }
    
    /// 解析条件语句
    ///
    /// - Returns: AST
    private func parseIfExpr() -> ExprAST? {
        lexer.nextToken()
        let cond = parseExpression()
        guard cond != nil else {
            return nil
        }
        guard lexer.currentToken!.token == .then else {
            fatalError("expected then.")
        }
        lexer.nextToken()
        let then = parseExpression()
        guard then != nil else {
            return nil
        }
        guard lexer.currentToken!.token == .else else {
            fatalError("expected else.")
        }
        lexer.nextToken()
        let `else` = parseExpression()
        guard `else` != nil else {
            return nil
        }
        return IfExprAST(cond!, then!, `else`!)
    }
    
    /// 解析For表达式
    ///
    /// - Returns: AST
    private func parseForExpr() -> ExprAST? {
        lexer.nextToken()
        guard lexer.currentToken!.token == .identifier else {
            fatalError("expected identifier after for.")
        }
        let idName = lexer.currentToken!.val
        lexer.nextToken()
        guard lexer.currentToken!.val == "=" else {
            fatalError("expected '=' after for.")
        }
        
        lexer.nextToken()
        let start = parseExpression()
        guard start != nil else {
            return nil
        }
        guard lexer.currentToken!.val == "," else {
            fatalError("expected ',' after start value.")
        }
        
        lexer.nextToken()
        let end = parseExpression()
        guard end != nil else {
            return nil
        }
        
        var step: ExprAST!
        if lexer.currentToken!.val == "," {
            lexer.nextToken()
            step = parseExpression()
            guard step != nil else {
                return nil
            }
        }
        
        guard lexer.currentToken!.token == .in else {
            fatalError("expected 'in' after for.")
        }
        lexer.nextToken()
        
        let body = parseExpression()
        guard body != nil else {
            return nil
        }
        
        return ForExprAST(idName, start!, end!, step, body!)
    }
    
    /// 解析一元表达式
    ///
    /// - Returns: AST
    private func parseUnaryExpr() -> ExprAST? {
        //当前token不是操作符，那就是基本类型
        if lexer.currentToken!.val == "(" ||
            lexer.currentToken!.val == "," ||
            Array(lexer.currentToken!.val)[0].isLetter ||
            Array(lexer.currentToken!.val)[0].isNumber {
            return parsePrimary()
        }
        
        let op = lexer.currentToken!.val
        lexer.nextToken()
        //这里需要递归的处理一元运算符，比如说 !! x，这里有两个!!需要处理
        if let operand = parseUnaryExpr() {
            return UnaryExprAST(op, operand)
        }
        return nil
    }
    
    /// 解析Var变量
    ///
    /// - Returns: AST
    private func parseVarExpr() -> ExprAST? {
        lexer.nextToken()
        var varNames: [(String, ExprAST?)] = []
        guard lexer.currentToken!.token == .identifier else {
            fatalError("Expected identifier after val.")
        }
        while true {
            let name = lexer.currentToken!.val
            lexer.nextToken()
            
            let expr: ExprAST? = nil
            if lexer.currentToken!.val == "=" {
                lexer.nextToken()
                let expr = parseExpression()
                guard expr != nil else {
                    return nil
                }
            }
            
            varNames.append((name, expr))
            
            if lexer.currentToken!.val != "," {
                break
            }
            lexer.nextToken()
            if lexer.currentToken!.token != .identifier {
                fatalError("Expected identifier list after var.")
            }
        }
        if lexer.currentToken!.token != .in {
            fatalError("Expected 'in' keyword after 'var'.")
        }
        lexer.nextToken()
        let body = parseExpression()
        guard body != nil else {
            return nil
        }
        return VarExprAST(varNames, body!)
    }
    
    /// 获取currentToken对应的运算符优先级
    ///
    /// - Returns: 优先级
    private func getTokenPrecedence() -> Int {
        if BinOpPrecedence[lexer.currentToken!.val] == nil {
            return -1
        } else {
            return Int(BinOpPrecedence[lexer.currentToken!.val]!)
        }
    }
    
}
