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

    func testInteger() {
        
        let list = [ 123 ]
        let dumped = list.jsonDump()
        XCTAssertEqual(dumped, """
[
  123
]
"""
        )
    }

    func testDouble() {
        
        let list = [ 123.45 ]
        let dumped = list.jsonDump()
        XCTAssertEqual(dumped, """
[
  123.45
]
"""
        )
    }

    
    static var allTests = [
        ("testString", testString),
    ]
}
