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
        } else if identifierStr == "binary" {
            return CurrentToken(token: .binary, val: "binary")
        } else if identifierStr == "unary" {
            return CurrentToken(token: .unary, val: "unary")
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
    if thisChar != ";" {
        lastChar = getChar()
    }
    
    return CurrentToken(token: .other, val: String(thisChar))
}

var content = Array("")
var i = 0
func getChar() -> Character {
    let char = content[i]
    i += 1
    return char
}

func mainLoop(_ input: String) {
    let blockArray = input.split(separator: ";")
    for block in blockArray {
        content = Array(block + ";")
        i = 0
        lastChar = " "
        getNextToken()
        switch currentToken!.token {
        case .def:
            handleDefinition()
            continue
        case .extern:
            handleExtern()
            continue
        case .number, .identifier:
            handleTopLevelExpression()
            continue
        default:
            continue
        }
    }
}
