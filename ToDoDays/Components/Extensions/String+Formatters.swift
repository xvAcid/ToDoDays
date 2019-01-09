//
//  String+Formatters.swift
//  ToDoDays
//
//  Created by xvacid on 19/11/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import Foundation

public extension String {
    /// formatted phone number by mask
    mutating func formattedPhoneNumber(code: Character, mask: String = "+X (XXX) XXX XX-XX") {
        var cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if cleanPhoneNumber.count == 0 {
            return
        }
        
        if cleanPhoneNumber[cleanPhoneNumber.startIndex] != code {
            cleanPhoneNumber.insert(code, at: cleanPhoneNumber.startIndex)
        }
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        
        self = result
    }
    
    /// format string to currency and return
    func formatCurrency() -> String {
        if !self.isEmpty {
            let numberFormatter = NumberFormatter()
            numberFormatter.groupingSeparator = " "
            numberFormatter.usesGroupingSeparator = true
            numberFormatter.numberStyle = .decimal
            return numberFormatter.string(from: NSNumber(value: Double(self)!))!
        }
        return ""
    }
    
    static func getCubicMeter() -> String {
        return "м\(String(format: "%C", 0x00B3))"
    }
    
    static func getSquareMeter() -> String {
        return "м\(String(format: "%C", 0x00B2))"
    }
    
    /// check valid phone number for login
    ///
    /// - Returns: true or false
    func validateLoginPhoneNumber() -> Bool {
        let cleanPhoneNumber    = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if cleanPhoneNumber.count > 0 {
            let phoneRegExp = "^\\d{11}$"
            let predicate   = NSPredicate(format: "SELF MATCHES %@", phoneRegExp)
            return predicate.evaluate(with: cleanPhoneNumber)
        }
        return false
    }
    
    func validatePhoneNumber() -> Bool {
        let cleanPhoneNumber    = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if cleanPhoneNumber.count > 0 {
            let phoneRegExp = "^((\\+)|())[0-9]{10}$"
            let predicate   = NSPredicate(format: "SELF MATCHES %@", phoneRegExp)
            return predicate.evaluate(with: cleanPhoneNumber)
        }
        return false
    }
}
