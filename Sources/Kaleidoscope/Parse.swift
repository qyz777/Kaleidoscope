//
//  Parse.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/28.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//

import Foundation

let binOpPrecedence: [String: Int] = ["<": 10, "+": 20, "-": 20, "*": 40]
func getTokenPrecedence() -> Int {
    if binOpPrecedence[currentToken!.val] == nil {
        return -1
    } else {
        return binOpPrecedence[currentToken!.val]!
    }
}

//解析变量引用和函数调用
func parseIdentifierExpr() -> ExprAST? {
    let idName = currentToken!.val
    getNextToken()
    if currentToken!.val != "(" {
        return VariableExprAST(idName)
    }
    getNextToken()
    var args: [ExprAST] = []
    if currentToken!.val != ")" {
        while true {
            let arg = parseExpression()
            guard arg != nil else {
                return nil
            }
            args.append(arg!)
            if currentToken!.val == ")" {
                break
            }
            if currentToken!.val != "," {
                fatalError("Expected ')' or ',' in argument list")
            }
            getNextToken()
        }
    }
    
    getNextToken()
    
    return CallExprAST(idName, args)
}

//解析数值常量
func parseNumberExpr() -> ExprAST {
    let result = NumberExprAST(Int(currentToken!.val)!)
    getNextToken()
    return result
}

//解析'('开头
func parseParenExpr() -> ExprAST? {
    getNextToken()
    let v = parseExpression()
    guard v != nil else {
        return nil
    }
    if currentToken!.val != ")" {
        fatalError("Expected '\(currentToken!.val)'")
    }
    getNextToken()
    return v
}

//解析基本表达式
func parsePrimary() -> ExprAST? {
    guard currentToken != nil else {
        return nil
    }
    if currentToken!.val == "(" {
        return parseParenExpr()
    }
    switch currentToken!.token {
    case .identifier:
        return parseIdentifierExpr()
    case .number:
        return parseNumberExpr()
    default:
        fatalError("unknow token when expecting an expression")
    }
}

func parseBinOpRHS(_ exprPrec: Int, _ lhs: inout ExprAST) -> ExprAST? {
    while true {
        let tokPrec = getTokenPrecedence()
        if tokPrec < exprPrec {
            return lhs
        }
        
        //获取二元运算符
        let binOp = currentToken
        getNextToken()
        
        //解析二元运算符右边的表达式
        var rhs = parsePrimary()
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

func parseExpression() -> ExprAST? {
    var lhs = parsePrimary()
    guard lhs != nil else {
        return nil
    }
    return parseBinOpRHS(0, &lhs!)
}

//解析函数原型
func parsePrototype() -> PrototypeAST {
    guard currentToken!.token == .identifier else {
        fatalError("Expected function name in prototype")
    }
    let fnName = currentToken!.val
    getNextToken()
    if currentToken!.val != "(" {
        fatalError("Expected '(' in prototype")
    }
    var argNames: [String] = []
    getNextToken()
    while currentToken!.token == .identifier {
        argNames.append(currentToken!.val)
        getNextToken()
    }
    if currentToken!.val != ")" {
        fatalError("Expected ')' in prototype")
    }
    getNextToken()
    return PrototypeAST(fnName, argNames)
}

//解析函数定义
func parseDefinition() -> FunctionAST? {
    getNextToken()
    let proto = parsePrototype()
    if let e = parseExpression() {
        return FunctionAST(proto, e)
    }
    return nil
}

func parseExtern() -> PrototypeAST {
    getNextToken()
    return parsePrototype()
}

func parseTopLevelExpr() -> FunctionAST? {
    if let e = parseExpression() {
        let proto = PrototypeAST("", [])
        return FunctionAST(proto, e)
    }
    return nil
}

//MARK: Top-Level Parse

func handleDefinition() {
    if let p = parseDefinition() {
        if let f = p.codeGen() {
            print("Parsed a function definition.")
            f.dump()
        }
    } else {
        getNextToken()
    }
}

func handleExtern() {
    let p = parseExtern()
    if let f = p.codeGen() {
        print("Parsed an extern.")
        f.dump()
    }
}

func handleTopLevelExpression() {
    if let p = parseTopLevelExpr() {
        if let f = p.codeGen() {
            print("Parsed a top-level expr.")
            f.dump()
        }
    } else {
        getNextToken()
    }
}
