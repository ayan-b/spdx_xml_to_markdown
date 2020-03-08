# SPDX XML to Markdown

Convert a spdx-xml License into markdown.

## Example

```dart
import 'package:spdx_xml_to_markdown/spdx_xml_to_markdown.dart';

void main() {
  var xmlString = """
<?xml version="1.0" encoding="UTF-8"?>
<SPDXLicenseCollection xmlns="http://www.spdx.org/license">
   <license isOsiApproved="true" licenseId="MIT" name="MIT License">
      <crossRefs>
         <crossRef>https://opensource.org/licenses/MIT</crossRef>
      </crossRefs>
    <text>
      <titleText>
         <p>MIT License</p>
      </titleText>
      <copyrightText>
         <p>Copyright (c) &lt;year&gt; &lt;copyright holders&gt;
         </p>
      </copyrightText>

      <p>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
         associated documentation files (the "Software"), to deal in the Software without restriction,
         including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
         and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
         subject to the following conditions:</p>
      <p>The above copyright notice and this permission notice
         <optional>(including the next paragraph)</optional>
         shall be included in all copies or substantial
         portions of the Software.</p>
      <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
         LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
         NO EVENT SHALL <alt match=".+" name="copyrightHolder">THE AUTHORS OR COPYRIGHT HOLDERS</alt> BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
         WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
         SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.</p>
    </text>
  </license>
</SPDXLicenseCollection>
  """;
  print(parse(xmlString));
}
```

See [`example`](./example/README.md) for more usage.

## Assumptions

- `alt`s are not printed.
- `optional`s are not printed.

## LICENSE

[BSD 3-Clause](./LICENSE)
