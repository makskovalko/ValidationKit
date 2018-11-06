//
//  Validator.swift
//  FunctionalFormFieldValidation
//
//  Created by Maxim Kovalko on 11/2/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import Foundation

//MARK: - Required field validator

public struct RequiredFieldError: Error {
    let errorDescription = "This field is required"
}

public func required(_ value: String?) -> ValidationResult<String> {
    guard let value = value, !value.isEmpty else { return .failure(RequiredFieldError()) }
    return .success(value)
}

public func nonEmpty<T: Collection>(_ seq: T) -> ValidationResult<T> {
    guard !seq.isEmpty else { return .failure(RequiredFieldError()) }
    return .success(seq)
}

//MARK: - Minimal field length validator

public struct MinimalFieldLengthError: Error {
    let minimalLength: Int
    var errorDescription: String? {
        return "This field must be at least \(minimalLength) characters long."
    }
}

public func minLength(_ length: Int) -> (String) -> ValidationResult<String> {
    return { x in
        return x.count < length
            ? .failure(MinimalFieldLengthError(minimalLength: length))
            : .success(x)
    }
}

//MARK: - Match by Regular Expression Validator

public struct PatternMatchError: Error {
    let pattern: String
    var errorDescription: String? {
        return "This field must match following pattern: `\(pattern)`."
    }
}

public func match(_ expression: NSRegularExpression) -> (String) -> ValidationResult<String> {
    return { x in
        return !expression.matches(in: x,
                                   options: [],
                                   range: NSRange(location: 0, length: x.count)).isEmpty
            ? .success(x)
            : .failure(PatternMatchError(pattern: expression.pattern))
    }
}

//MARK: - Enumeration Field Validator

public struct TypeMatchError<T>: Error {
    let type: T.Type
    var errorDescription: String? {
        return "This field must have value of type `\(type)`."
    }
}

public func type<T: RawRepresentable>(_ enumType: T.Type) -> (T.RawValue) -> ValidationResult<T> {
    return { x in
        guard let value = enumType.init(rawValue: x) else {
            return .failure(TypeMatchError<T>(type: enumType))
        }
        return .success(value)
    }
}

//MARK: - String fixed length validator

public struct StringExactLengthValidator: Error {
    let length: Int
    var errorDescription: String? {
        return "The value must have exactly \(length) characters."
    }
}

public func length(_ length: Int) -> (String) -> ValidationResult<String> {
    return { x in
        return length == x.count
            ? .success(x)
            : .failure(StringExactLengthValidator(length: length))
    }
}
