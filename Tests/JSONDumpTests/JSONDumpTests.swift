import XCTest
@testable import JSONDump

final class JSONDumpTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(JSONDump().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
