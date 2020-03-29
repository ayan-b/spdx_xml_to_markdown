import 'xml_element.dart';

Map<String, dynamic> getAttributes(String startTag) {
  final attributes = startTag.substring(1, startTag.length - 1).split(' ');
  var attributesMap = {};
  for (var i = 1; i < attributes.length; ++i) {
    var key = attributes[i].split('=')[0];
    var value = attributes[i].split('=')[1];
    value = value.substring(1, value.length - 1);
    attributesMap[key] = value;
  }
  return attributesMap;
}

/// Remove newline and the following extra spaces. Useful for removing spaces
/// between lines, like:
/// ```xml
/// <Hello>
///   <Inner1>
///     <Inner2>
///       I am a very long line residing in inner2. Note
///       the spaces before this line. They are for indentation
///       only.
///     </Inner2>
///   </Inner1>
/// </Hello>
/// ```
/// The spaces between `Note` and `the`, `indentation` and `only` will be
/// removed by this function.
String removeExtraSpaces(String data) {
  return data.replaceAll(RegExp(r'([\n][\s]*)+'), '\n');
}

/// Consume the string `consume` and advance the string `content` by the length
/// of `consume`. Returns the advanced string.
String advance(String content, String consume) {
  var consumeLength = consume.length;
  content = content.substring(consumeLength);
  return content;
}

/// Removes the first line from a file.
String removeFirstLine(String xmlString) {
  var firstNewLineCharacter = xmlString.indexOf('\n');
  return xmlString.substring(firstNewLineCharacter + 1);
}

/// An XML parser which takes `xmlString`, the XML document and `root`, a
/// node having no content on its own. The root acts as a parent to the first
/// tag of the XML document.
///
/// Consider the following XML document (first line removed):
///
/// ```xml
/// <Hello>
///   <Foo>
///     <p> I am foo </p>
///     <p> I am foo, too. </p>
///   <Foo>
///   <Bar>
///     <p> I am bar </p>
///     <p> I am bar, too. </p>
///   </Bar>
/// </Hello>
/// ```
///
/// This document will be converted to the following tree after parsing:
/// ```
///       root
///         |
///       Hello
///     /       \
///   Foo       Bar
///   / \       / \
///   p p       p p
/// ```
///
/// Returns the `root` of the generated tree after parsing the document.
XmlElement parser(String xmlString, XmlElement root) {
  // trim new line or white space at the end
  xmlString = xmlString.trim();
  // remove first line
  xmlString = removeFirstLine(xmlString);
  var foundStartTagCount = 0;
  var stack = <String>[];
  var prevXmlElement;
  var currentXmlElement = root;
  while (xmlString.isNotEmpty) {
    // XML empty-element tag
    // See https://www.w3.org/TR/xml/#sec-starttags
    if (xmlString.indexOf(RegExp(r'<([s\S]*?)/>')) == 0) {
      var emptyElementTag = RegExp(r'<([s\S]*?)/>').stringMatch(xmlString);
      currentXmlElement.setData(emptyElementTag);
      xmlString = advance(xmlString, emptyElementTag);
      // parse end tag
    } else if (xmlString.indexOf(r'</') == 0) {
      --foundStartTagCount;
      var endTag = RegExp(r'^</([\s\S]*?)>').stringMatch(xmlString);
      var endTagLength = endTag.length;
      xmlString = advance(xmlString, endTag);
      endTag = endTag.substring(2, endTagLength - 1);
      var startTag = stack[stack.length - 1];
      // if start tag doesn't match end tag, it is an ill-formated XML Document
      assert(startTag == endTag);
      // pop from stack
      stack = stack.sublist(0, stack.length - 1);
      // push currentXmlElement it to parent's children list
      prevXmlElement.children.add(currentXmlElement);
      // roll back one level above
      currentXmlElement = prevXmlElement;
      prevXmlElement = prevXmlElement.parent;
      // parse start tag
    } else if (xmlString.indexOf('<') == 0) {
      ++foundStartTagCount;
      var startTag = RegExp(r'^<([\s\S]*?)>').stringMatch(xmlString);
      if (startTag != null && startTag.isNotEmpty) {
        if (startTag == '<bullet>') {
          var data = RegExp(r'>([\s\S]*?)</').stringMatch(xmlString);
          data = data.substring(1, data.length - 2);
          currentXmlElement.setData(data + ' ');
          xmlString = advance(xmlString, startTag + data + '</button>');
          continue;
        }
        var startTagLength = startTag.length;
        xmlString = advance(xmlString, startTag);
        startTag = startTag.substring(1, startTagLength - 1);
        startTag = startTag.split(' ')[0];
        stack.add(startTag);
        // create a new XmlElement and build the parent connection
        prevXmlElement = currentXmlElement;
        currentXmlElement = XmlElement();
        currentXmlElement.tag = startTag;
        currentXmlElement.parent = prevXmlElement;
      }
      // parse data
    } else if (foundStartTagCount > 0) {
      var data = RegExp(r'([\s\S]*?)<').stringMatch(xmlString);
      if (data != null) {
        data = data.substring(0, data.length - 1);
        var dataLength = data.length;
        xmlString = xmlString.substring(dataLength);
        data = removeExtraSpaces(data);
        // remove extra new lines at the end, if any
        currentXmlElement.setData(data.trim());
      }
    } else {
      // spaces and new lines between an ending tag and a start tag
      var extraSpaces = RegExp(r'([\s\S]*?)<').stringMatch(xmlString);
      xmlString = xmlString.substring(extraSpaces.length - 1);
    }
  }
  return root;
}
