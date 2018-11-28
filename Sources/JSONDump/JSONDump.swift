// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/11/2018.
//  All code (c) 2018 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/**
 Protocol that classes can implement to indicate that they can be converted to a valid JSON object.
 */

public protocol JSONDumpable {
    func asValidJSONObject() -> Any
}

extension JSONDumpable {

    /**
     Dump the object as a json string using the default formatting options.
     */
    
    public func jsonDump() -> String {
        return JSONDump.dump(value: self, options: JSONDump.defaultDumpOptions)
    }
    
    /**
     Dump the object as a json string using specific options
     */
    
    public func jsonDump(options: JSONSerialization.WritingOptions) -> String {
        return JSONDump.dump(value: self, options: options)
    }
}

class JSONDump {
    
    /**
     Pretty print by default. Also sort keys if possible.
     */
    
    public static var defaultDumpOptions : JSONSerialization.WritingOptions {
        if #available(macOS 10.13, *) {
            return [.prettyPrinted, .sortedKeys]
        } else {
            return [.prettyPrinted]
        }
    }

    /**
     Don't pretty print, but sort keys if possible.
     */
    
    public static var compactDumpOptions : JSONSerialization.WritingOptions {
        if #available(macOS 10.13, *) {
            return [.sortedKeys]
        } else {
            return []
        }
    }
    
    /**
     Turn a value into something that can be serialised as JSON.
     */
    
    class func asValidJSONObject(_ value: Any) -> Any {
        switch value {
        case let dumpable as JSONDumpable:
            return dumpable.asValidJSONObject()
            
        case is NSNumber:
            return value
            
            #if os(Linux)
            // On Linux we need some additional handling for fundamental types.
            // On other platforms these are already handled by casting to NSNumber.
        case is Int, is Double, is Bool:
            return value
        case is NSString:
            return "\"\(value)\""
            #endif
            
        default:
            return "\(value)"
        }
    }
    
    /**
     Make a sanitized version of the object, then try to encode it as JSON.
     If the encoding still fails, we fall back on string interpolation.
    */
    
    class func dump(value: Any, options: JSONSerialization.WritingOptions) -> String {
        let sanitized = asValidJSONObject(value)
        if let data = try? JSONSerialization.data(withJSONObject: sanitized, options: options)  {
            if let encoded = String(data: data, encoding: .utf8) {
                return encoded
            }
        }
        
        return "\(sanitized)"
    }
    
}

extension NSValue: JSONDumpable {
    public func asValidJSONObject() -> Any {
        let type = String(cString:objCType)
        switch type {
        case "{CGPoint=dd}":
            let point = pointValue
            return ["x": point.x, "y": point.y]
        case "{CGRect={CGPoint=dd}{CGSize=dd}}":
            let rect = rectValue
            return ["x": rect.origin.x, "y": rect.origin.y, "width": rect.width, "height": rect.height]
        default:
            return self
        }
    }
}

extension Array: JSONDumpable {
    public func asValidJSONObject() -> Any {
        var sanitized = Array<Any>()
        for item in self {
            sanitized.append(JSONDump.asValidJSONObject(item))
        }
        return sanitized
    }
}

extension Dictionary: JSONDumpable {
    public func asValidJSONObject() -> Any {
        var sanitized = Dictionary<String, Any>()
        for item in self {
            if let key = item.key as? String {
                let value: Any
                if let subdict = item.value as? Dictionary<Key, Any> {
                    value = subdict.asValidJSONObject()
                } else {
                    value = JSONDump.asValidJSONObject(item.value)
                }
                sanitized[key] = value
            }
        }
        return sanitized
    }
}
