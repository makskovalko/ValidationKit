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
