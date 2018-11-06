# ValidationKit
Functional ValidationKit for Swift

# Features
- [x] Required validation
- [x] Regular Expression
- [x] Non-empty collections and strings
- [x] Type-match validation (for enumerations)
- [x] Length validation

### Monad Interface
```swift
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

```
### Examples
```swift
let emailValidator = required(email)
      >>= minLength(10)
      >>= match(NSRegularExpression(pattern: "^\\S+@\\S+$", options: []))
      >>= allUppercased
```

```swift
enum Gender: String {
    case man
    case woman
}
        
let validGender = type(Gender.self)
guard case .success(let gender) = validGender("man") ...
```

### How to write validators

#### Min Length Validator
```swift
public func minLength(_ length: Int) -> (String) -> ValidationResult<String> {
    return { x in
        return x.count < length
            ? .failure(MinimalFieldLengthError(minimalLength: length))
            : .success(x)
    }
}

public struct MinimalFieldLengthError: Error {
    let minimalLength: Int
    var errorDescription: String? {
        return "This field must be at least \(minimalLength) characters long."
    }
}
```

#### Type-match Validator
```swift
public func type<T: RawRepresentable>(_ enumType: T.Type) -> (T.RawValue) -> ValidationResult<T> {
    return { x in
        guard let value = enumType.init(rawValue: x) else {
            return .failure(TypeMatchError<T>(type: enumType))
        }
        return .success(value)
    }
}

public struct TypeMatchError<T>: Error {
    let type: T.Type
    var errorDescription: String? {
        return "This field must have value of type `\(type)`."
    }
}
```
