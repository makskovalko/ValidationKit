//
//  Operators.swift
//  ValidationKit
//
//  Created by Maxim Kovalko on 11/6/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

//MARK: - Bindings

precedencegroup LeftAssociativity {
    associativity: left
}

infix operator >>>: LeftAssociativity

public func validate<Input, Output>(_ value: ValidationResult<Input>,
                                    f: (Input) -> ValidationResult<Output>) -> ValidationResult<Output> {
    switch value {
    case .success(let value): return f(value)
    case .failure(let error): return .failure(error)
    }
}

public func >>><Input, Output>(_ value: ValidationResult<Input>,
                               f: (Input) -> ValidationResult<Output>) -> ValidationResult<Output> {
    return validate(value, f: f)
}
