// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/11/2018.
//  All code (c) 2018 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

protocol JSONDumpable {
    func dumpableAsJSON() -> Any
    func jsonDump() -> String
}

extension JSONDumpable {
    func jsonDump() -> String {
        let sanitzed = self.dumpableAsJSON()
        return JSONDump.dump(sanitzed)
    }
}

class JSONDump {
    class func sanitized(_ value: Any) -> Any {
        let result: Any

        if let value = value as? JSONDumpable {
            result = value.dumpableAsJSON()
        } else {
            result = "\(value)"
        }
        return result
    }

    class func dump(_ sanitized: Any) -> String {
        if let data = try? JSONSerialization.data(withJSONObject: sanitized, options: [.prettyPrinted, .sortedKeys])  {
            if let encoded = String(data: data, encoding: .utf8) {
                return encoded
            }
        }

        return "\(sanitized)"
    }

}

extension NSString: JSONDumpable {
    func dumpableAsJSON() -> Any {
        return self
    }
}

extension NSValue: JSONDumpable {
    func dumpableAsJSON() -> Any {
        return self
    }
}

extension Array: JSONDumpable {
    func dumpableAsJSON() -> Any {
        var sanitized = Array<Any>()
        for item in self {
            sanitized.append(JSONDump.sanitized(item))
        }
        return sanitized
    }

}

extension Dictionary: JSONDumpable {

    func dumpableAsJSON() -> Any {
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
