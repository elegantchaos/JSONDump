# JSONDump

For debugging purposes, it's useful to be able to dump a dictionary or array containing arbitrary objects as a JSON string.

However, for many data types, JSONSerialization doesn't know how to encode them.

This small utility provides some fallback logic which allows you to call `jsonDump()` on any string or array, and
to get back some vaguely sensible JSON.

It does this by falling back to just encoding the object as a string, for anything that can't be encoded properly.
