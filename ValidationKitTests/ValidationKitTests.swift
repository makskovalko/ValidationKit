//
//  ValidationKitTests.swift
//  ValidationKitTests
//
//  Created by Maxim Kovalko on 11/6/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import XCTest
@testable import ValidationKit

class ValidationKitTests: XCTestCase {

    func testReqularExpressions() {
        let allUppercased = try! match(NSRegularExpression(pattern: "^[A-Z]+$", options: []))
        guard case .success(let value) = allUppercased("test".uppercased()) else { XCTFail(); return }
        XCTAssertEqual("test".uppercased(), value)
        
        let validationResult = required("VALUE")
            >>> minLength(5)
            >>> allUppercased
        
        XCTAssertNotNil(validationResult.value)
        XCTAssertEqual(validationResult.value, "VALUE")
    }
    
    func testValidateEmail() {
        let validEmail = try! match(NSRegularExpression(pattern: "^\\S+@\\S+$", options: []))
        XCTAssertNotNil(validEmail("test@test.com").value)
        XCTAssertNotNil(validEmail("asd").error)
    }
    
    func testTypeMatch() {
        enum Gender: String {
            case man
            case woman
            case unknows
        }
        
        let validGender = type(Gender.self)
        guard case .success(let gender) = validGender("man") else { XCTFail(); return }
        XCTAssertEqual(Gender.man, gender)
    }
    
    func testNonEmpty() {
        let value = nonEmpty(Array(0...10)).value
        XCTAssertTrue(value?.isEmpty == false)
        
        XCTAssertNil(nonEmpty([]).value)
        XCTAssertNotNil(nonEmpty([]).error)
    }

}
