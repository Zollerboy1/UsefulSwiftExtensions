import XCTest
@testable import UsefulExtensions

final class UsefulExtensionsTests: XCTestCase {
    func testNumberformatting() throws {
        XCTAssertEqual("\(5, paddedToWidth: 3)", "  5")
        XCTAssertEqual("\(5, paddedToWidth: 3, using: .zero)", "005")
        XCTAssertEqual("\(5, paddedToWidth: 3, forceSign: true)", " +5")
        XCTAssertEqual("\(5, paddedToWidth: 3, using: .zero, forceSign: true)", "+05")
        XCTAssertEqual("\(-5, paddedToWidth: 3)", " -5")
        XCTAssertEqual("\(-5, paddedToWidth: 3, using: .zero)", "-05")
        
        XCTAssertEqual("\(15, radix: 2)", "1111")
        XCTAssertEqual("\(15, radix: 8)", "17")
        XCTAssertEqual("\(15, radix: 10)", "15")
        XCTAssertEqual("\(15, radix: 16)", "f")
        XCTAssertEqual("\(15, radix: 16, uppercaseLetters: true)", "F")
        
        
        XCTAssertEqual("\(0.5, precision: 2)", "0.50")
        XCTAssertEqual("\(3.141, precision: 2)", "3.14")
    }
}
