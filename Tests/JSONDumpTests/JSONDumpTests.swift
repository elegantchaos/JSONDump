import XCTest
@testable import JSONDump

final class JSONDumpTests: XCTestCase {
    func testString() {

        let list = [ "test" ]
        XCTAssertEqual(list.jsonDump(), """
[
  "test"
]
"""
        )
    }

    static var allTests = [
        ("testString", testString),
    ]
}
