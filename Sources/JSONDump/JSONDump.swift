// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/11/2018.
//  All code (c) 2018 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol JSONDumpable {
    func dumpableAsJSON() -> Any
    func jsonDump() -> String
}

extension JSONDumpable {
    public func jsonDump() -> String {
        let sanitzed = self.dumpableAsJSON()
        return JSONDump.dump(sanitzed)
    }
}

class JSONDump {
    class func sanitized(_ value: Any) -> Any {
        let result: Any

        if let value = value as? JSONDumpable {
            result = value.dumpableAsJSON()
        } else if let number = value as? NSNumber {
            result = number
        } else {
            result = "\(value)"
        }
        return result
    }

    class func dump(_ sanitized: Any) -> String {
        let options: JSONSerialization.WritingOptions
        if #available(macOS 10.13, *) {
            options = [.prettyPrinted, .sortedKeys]
        } else {
            options = [.prettyPrinted]
        }

        if let data = try? JSONSerialization.data(withJSONObject: sanitized, options:options)  {
            if let encoded = String(data: data, encoding: .utf8) {
                return encoded
            }
        }

        return "\(sanitized)"
    }

}

extension NSString: JSONDumpable {
    public func dumpableAsJSON() -> Any {
        return self
    }
}

extension NSValue: JSONDumpable {
    public func dumpableAsJSON() -> Any {
        return self
    }
}

extension Array: JSONDumpable {
    public func dumpableAsJSON() -> Any {
        var sanitized = Array<Any>()
        for item in self {
            sanitized.append(JSONDump.sanitized(item))
        }
        return sanitized
    }
}

extension Dictionary: JSONDumpable {

    public func dumpableAsJSON() -> Any {
        var sanitized = Dictionary<String, Any>()
        for item in self {
            if let key = item.key as? String {
                let value: Any
                if let subdict = item.value as? Dictionary<Key, Any> {
                    value = subdict.dumpableAsJSON()
                } else {
                    value = JSONDump.sanitized(item.value)
                }
                sanitized[key] = value
            }
        }
        return sanitized
    }

}
