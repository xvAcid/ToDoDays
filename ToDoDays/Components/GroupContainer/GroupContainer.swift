//
//  GroupContainer.swift
//  ToDoDays
//
//  Created by xvacid on 19/11/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import Foundation

class GroupContainer: NSObject {
    private var groupedData: [String: Any] = [:]

    private func getTypeName(name: String) -> String {
        if name.contains("Optional") {
            let components = name.components(separatedBy: "<")
            if components.count > 1 {
                guard var newName = components.last else { return name }
                newName.removeLast()
                return newName
            }
        }
        return name
    }

    func add<T>(_ value: T, _ keyId: String = "") {
        var key = getTypeName(name: "\(T.self)")
        if !keyId.isEmpty { key += "_\(keyId)" }
        assert(groupedData[key] == nil, "For adding two or more equal key, you may have use keyId field")
        groupedData[key] = value
    }
    
    func get<T>(_ keyId: String = "") -> T? {
        var key = getTypeName(name: "\(T.self)")
        if !keyId.isEmpty { key += "_\(keyId)" }
        let object = groupedData[key]
        
        guard let genericValue = object as? T, object is T else { return nil }
        return genericValue
    }
}
