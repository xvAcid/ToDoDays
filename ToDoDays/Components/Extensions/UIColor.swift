//
//  UIColor.swift
//  ToDoDays
//
//  Created by xvacid on 19/11/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: Int) {
        self.init(
            red: CGFloat(r)     / 255.0,
            green: CGFloat(g)   / 255.0,
            blue: CGFloat(b)    / 255.0,
            alpha: CGFloat(a)   / 255.0)
    }
    
    convenience init(hex: String) {
        var hexValue = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        guard hexValue.count == 3 || hexValue.count == 6 else { self.init(white: 1.0, alpha: 0.0); return }
        
        if hexValue.count == 3 {
            for (index, char) in hexValue.enumerated() {
                hexValue.insert(char, at: hexValue.index(hexValue.startIndex, offsetBy: index * 2))
            }
        }
        
        self.init(
            red:   CGFloat((Int(hexValue, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hexValue, radix: 16)! >> 8) & 0xFF)  / 255.0,
            blue:  CGFloat((Int(hexValue, radix: 16)!) & 0xFF)       / 255.0,
            alpha: 1.0)
    }
}
