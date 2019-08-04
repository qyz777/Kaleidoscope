//
//  Lexer.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/28.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//

import Foundation

/// 当前正在解析的token
struct CurrentToken {
    var token: Token
    var val: String
}

protocol LexerDelegate: class {
    
    /// 分析到token为def关键字开头，需要解析为函数
    ///
    /// - Parameter lexer: Lexer实例
    func lexerWithDefinition(_ lexer: Lexer)
    
    /// 分析到extern开头，需要解析导出方法
    ///
    /// - Parameter lexer: Lexer实例
    func lexerWithExtern(_ lexer: Lexer)
    
    /// 解析到顶级表达式(调用方法、表达式等)
    ///
    /// - Parameter lexer: Lexer实例
    func lexerWithTopLevelExpression(_ lexer: Lexer)
    
}

class Lexer {
    
    /// 当前的token
    public var currentToken: CurrentToken?
    
    public weak var delegate: LexerDelegate?
    
    private var lastChar: Character = " "
    
    private var index = 0
    
    /// 代码内容
    private var source: [Character] = []
    
}

extension Lexer {
    
    /// 解析代码
    ///
    /// - Parameter sourceInput: 代码数据源
    public func start(_ sourceInput: String) {
        let blockArray = sourceInput.split(separator: ";")
        for block in blockArray {
            source = Array(block + ";")
            index = 0
            lastChar = " "
            nextToken()
            switch currentToken!.token {
            case .def:
                delegate?.lexerWithDefinition(self)
                continue
            case .extern:
                delegate?.lexerWithExtern(self)
                continue
            case .number, .identifier:
                delegate?.lexerWithTopLevelExpression(self)
                continue
            default:
                //目前会出现'\n'之类的符号，还没想好怎么处理
                continue
            }
        }
    }
    
    /// 获取下一个currentToken
    public func nextToken() {
        var identifierStr = ""
        while lastChar.isWhitespace {
            lastChar = getChar()
        }
        
        //如果开头是字母的话说明是identifier类型或者是其他关键字
        if lastChar.isLetter {
            identifierStr = String(lastChar)
            lastChar = getChar()
            while lastChar.isNumber || lastChar.isLetter {
                identifierStr.append(lastChar)
                lastChar = getChar()
            }
            
            if identifierStr == "def" {
                currentToken = CurrentToken(token: .def, val: "def")
            } else if identifierStr == "extern" {
                currentToken = CurrentToken(token: .extern, val: "extern")
            } else if identifierStr == "if" {
                currentToken = CurrentToken(token: .if, val: "if")
            } else if identifierStr == "then" {
                currentToken = CurrentToken(token: .then, val: "then")
            } else if identifierStr == "else" {
                currentToken = CurrentToken(token: .else, val: "else")
            } else if identifierStr == "for" {
                currentToken = CurrentToken(token: .for, val: "for")
            } else if identifierStr == "in" {
                currentToken = CurrentToken(token: .in, val: "in")
            } else if identifierStr == "binary" {
                currentToken = CurrentToken(token: .binary, val: "binary")
            } else if identifierStr == "unary" {
                currentToken = CurrentToken(token: .unary, val: "unary")
            } else if identifierStr == "var" {
                currentToken = CurrentToken(token: .var, val: "var")
            } else {
                currentToken = CurrentToken(token: .identifier, val: identifierStr)
            }
            return
        }
        
        //是数字开头的话说明这个是一个数值
        if lastChar.isNumber || lastChar == "." {
            var numStr = ""
            repeat {
                numStr.append(lastChar)
                lastChar = getChar()
            } while lastChar.isNumber || lastChar == "."
            currentToken = CurrentToken(token: .number, val: numStr)
            return
        }
        
        //遇到";"说明这一个函数块结束了
        let thisChar = lastChar
        if thisChar != ";" {
            lastChar = getChar()
        }
        
        //返回其他类型仅作为占位使用，实际上走到这里再解析currentToken会崩溃
//        currentToken = nil
        currentToken = CurrentToken(token: .other, val: String(thisChar))
    }
    
}

extension Lexer {
    
    private func getChar() -> Character {
        let char = source[index]
        index += 1
        return char
    }
    
}
