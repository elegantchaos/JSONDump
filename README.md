# JSONDump

When debugging, it's useful to be able to dump a dictionary or array containing arbitrary objects as a JSON string.

By default though, JSONSerialization doesn't know how to encode anything other than strings, numbers, bools, lists and dictionaries.

This small project provides some fallback logic which allows you to call `jsonDump()` on any list or array, and
to get back some vaguely sensible JSON.

It does this by modifying a copy of the collection before dumping, and replacing any non-JSON objects with
alternatives. In some cases the replacements are fundamental types, or dictionaries composed of fundamental types.

You can declare conformance to a protocol for a type if you want to supply your own replacement for it.

For any type that doesn't have any other options, the code falls back to string interpolation.


## Usage:

```swift
let dict: [String:Any] = [
"date" : Date(timeIntervalSince1970: 0),
"double": 123.45,
"integer": 123
]

print(dict.jsonDump())

let list = [ 123.45, 1, 42, "foo", "bar" ]
print(list.jsonDump())
```


