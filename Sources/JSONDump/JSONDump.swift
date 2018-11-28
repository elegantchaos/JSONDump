// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/11/2018.
//  All code (c) 2018 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol JSONDumpable {
    func dumpableAsJSON() -> Any
}

extension JSONDumpable {
    
    public func jsonDump() -> String {
        return JSONDump.dump(value: self, options: JSONDump.defaultDumpOptions)
    }
    
    public func jsonDump(options: JSONSerialization.WritingOptions) -> String {
        return JSONDump.dump(value: self, options: options)
    }
}

class JSONDump {
    static var defaultDumpOptions : JSONSerialization.WritingOptions {
        if #available(macOS 10.13, *) {
            return [.prettyPrinted, .sortedKeys]
        } else {
            return [.prettyPrinted]
        }
    }
    
    class func dumpableAsJSON(_ value: Any) -> Any {
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

    class func dump(value: Any, options: JSONSerialization.WritingOptions) -> String {
        let sanitized = dumpableAsJSON(value)
        if let data = try? JSONSerialization.data(withJSONObject: sanitized, options: options)  {
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
            sanitized.append(JSONDump.dumpableAsJSON(item))
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
                    value = JSONDump.dumpableAsJSON(item.value)
                }
                sanitized[key] = value
            }
        }
        return sanitized
    }

}
