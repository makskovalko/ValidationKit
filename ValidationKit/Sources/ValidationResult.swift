//
//  ValidationResult.swift
//  ValidationKit
//
//  Created by Maxim Kovalko on 11/6/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

//MARK: - Validation Result

public enum ValidationResult<Value>: CustomStringConvertible {
    case success(Value)
    case failure(Error)
    
    var value: Value? {
        guard case .success(let value) = self else { return nil }
        return value
    }
    
    var error: Error? {
        guard case .failure(let error) = self else { return nil }
        return error
    }
    
    public var description: String {
        switch self {
        case .success(let value):
            return "\(value)"
        case .failure(let error):
            return error.localizedDescription
        }
    }
}
