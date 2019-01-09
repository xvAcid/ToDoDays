//
//  Numbers.swift
//  ToDoDays
//
//  Created by xvacid on 19/11/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import Foundation

// swiftlint:disable all

extension Int {
    @discardableResult static prefix    func ++(x: inout Int) -> Int    { x += 1; return x }
    @discardableResult static postfix   func ++(x: inout Int) -> Int    { defer { x += 1 }; return x }
    @discardableResult static prefix    func --(x: inout Int) -> Int    { x -= 1; return x }
    @discardableResult static postfix   func --(x: inout Int) -> Int    { defer { x -= 1 }; return x }
}

extension Int64 {
    @discardableResult static prefix    func ++(x: inout Int64) -> Int64    { x += 1; return x }
    @discardableResult static postfix   func ++(x: inout Int64) -> Int64    { defer { x += 1 }; return x }
    @discardableResult static prefix    func --(x: inout Int64) -> Int64    { x -= 1; return x }
    @discardableResult static postfix   func --(x: inout Int64) -> Int64    { defer { x -= 1 }; return x }
}

extension UInt {
    @discardableResult static prefix    func ++(x: inout UInt) -> UInt  { x += 1; return x }
    @discardableResult static postfix   func ++(x: inout UInt) -> UInt  { defer { x += 1 }; return x }
    @discardableResult static prefix    func --(x: inout UInt) -> UInt  { x -= 1; return x }
    @discardableResult static postfix   func --(x: inout UInt) -> UInt  { defer { x -= 1 }; return x }
}

extension UInt64 {
    @discardableResult static prefix    func ++(x: inout UInt64) -> UInt64  { x += 1; return x }
    @discardableResult static postfix   func ++(x: inout UInt64) -> UInt64  { defer { x += 1 }; return x }
    @discardableResult static prefix    func --(x: inout UInt64) -> UInt64  { x -= 1; return x }
    @discardableResult static postfix   func --(x: inout UInt64) -> UInt64  { defer { x -= 1 }; return x }
}

extension Float {
    @discardableResult static prefix    func ++(x: inout Float) -> Float    { x += 1; return x }
    @discardableResult static postfix   func ++(x: inout Float) -> Float    { defer { x += 1 }; return x }
    @discardableResult static prefix    func --(x: inout Float) -> Float    { x -= 1; return x }
    @discardableResult static postfix   func --(x: inout Float) -> Float    { defer { x -= 1 }; return x }
}

extension Double {
    @discardableResult static prefix    func ++(x: inout Double) -> Double  { x += 1; return x }
    @discardableResult static postfix   func ++(x: inout Double) -> Double  { defer { x += 1 }; return x }
    @discardableResult static prefix    func --(x: inout Double) -> Double  { x -= 1; return x }
    @discardableResult static postfix   func --(x: inout Double) -> Double  { defer { x -= 1 }; return x }
}
