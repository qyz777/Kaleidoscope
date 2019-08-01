//
//  Lexer.swift
//  Kaleidoscope
//
//  Created by Q YiZhong on 2019/7/28.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//

import Foundation

struct CurrentToken {
    var token: Token
    var val: String
}

var currentToken: CurrentToken?
func getNextToken() {
    currentToken = getToken()
}

var lastChar: Character = " "
func getToken() -> CurrentToken {
    var identifierStr = ""
    while lastChar.isWhitespace {
        lastChar = getChar()
    }
    
    if lastChar.isLetter {
        identifierStr = String(lastChar)
        
        lastChar = getChar()
        while lastChar.isNumber || lastChar.isLetter {
            identifierStr.append(lastChar)
            lastChar = getChar()
        }
        if identifierStr == "def" {
            return CurrentToken(token: .def, val: "def")
        } else if identifierStr == "extern" {
            return CurrentToken(token: .extern, val: "extern")
        } else if identifierStr == "if" {
            return CurrentToken(token: .if, val: "if")
        } else if identifierStr == "then" {
            return CurrentToken(token: .then, val: "then")
        } else if identifierStr == "else" {
            return CurrentToken(token: .else, val: "else")
        } else if identifierStr == "for" {
            return CurrentToken(token: .for, val: "for")
        } else if identifierStr == "in" {
            return CurrentToken(token: .in, val: "in")
        } else {
            return CurrentToken(token: .identifier, val: identifierStr)
        }
    }
    
    if lastChar.isNumber || lastChar == "." {
        var numStr = ""
        repeat {
            numStr.append(lastChar)
            lastChar = getChar()
        } while lastChar.isNumber || lastChar == "."
        return CurrentToken(token: .number, val: numStr)
    }
    
    let thisChar = lastChar
    lastChar = getChar()
    
    return CurrentToken(token: .other, val: String(thisChar))
}

var content = Array("")
var i = 0
func getChar() -> Character {
    let char = content[i]
    i += 1
    return char
}

func mainLoop() {
    while true {
        if currentToken!.val == ";" || currentToken!.val == "" {
            break
        }
        switch currentToken!.token {
        case .def:
            handleDefinition()
            break
        case .extern:
            handleExtern()
            break
        case .number, .identifier, .other:
            handleTopLevelExpression()
            break
        case .if, .then, .else, .for, .in:
            break
        }
    }
    i = 0
}
