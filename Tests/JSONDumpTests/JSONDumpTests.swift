import XCTest
@testable import JSONDump

final class JSONDumpTests: XCTestCase {
    func testString() {

        let list = [ "test" ]
        XCTAssertEqual(list.jsonDump(options: []), "[\"test\"]")
    }

    func testInteger() {
        
        let list = [ 123 ]
        let dumped = list.jsonDump(options: [])
        XCTAssertEqual(dumped, "[123]")
    }

    func testDouble() {
        
        let list = [ 123.45 ]
        let dumped = list.jsonDump(options: [])
        XCTAssertEqual(dumped, "[123.45]")
    }

    func testBool() {
        
        let list = [ true ]
        let dumped = list.jsonDump(options: [])
        XCTAssertEqual(dumped, "[true]")
    }
    
    func testNSString() {
        
        let list = [ "test" as NSString ]
        XCTAssertEqual(list.jsonDump(options: []), "[\"test\"]")
    }
    
    func testNSNumber() {
        
        let list = [ 123 as NSNumber ]
        let dumped = list.jsonDump(options: [])
        XCTAssertEqual(dumped, "[123]")
    }
    
    func testNSNumberDouble() {
        
        let list = [ 123.45 as NSNumber ]
        let dumped = list.jsonDump(options: [])
        XCTAssertEqual(dumped, "[123.45]")
    }

    func testDate() {
        
        let list = [ Date(timeIntervalSinceReferenceDate: 0) ]
        let dumped = list.jsonDump(options: [])
        XCTAssertEqual(dumped, "[\"2001-01-01 00:00:00 +0000\"]")
    }


    func testDictionary() {
        
        let dict: [String:Any] = [
            "date" : Date(timeIntervalSince1970: 0),
            "double": 123.45,
        "integer": 123
        ]
        
        let dumped = dict.jsonDump()
        XCTAssertEqual(dumped, """
{
  "date" : "1970-01-01 00:00:00 +0000",
  "double" : 123.45,
  "integer" : 123
}
"""
        )
    }

}
