import 'dart:io';

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

dynamic readFile(String uri) {
  var xmlString = File(uri).readAsStringSync();
  // trim new line or white space at the end
  xmlString = xmlString.trim();
  return xmlString;
}

String removeExtraSpaces(String data) {
  return data.replaceAll(RegExp(r'([\n][\s]*)+'), '\n');
}

String advance(String content, String consume) {
  var consumeLength = consume.length;
  content = content.substring(consumeLength);
  return content;
}

XmlElement parser(String xmlString, XmlElement root) {
  var foundStartTagCount = 0;
  var stack = <String>[];
  var prevXmlElement;
  var currentXmlElement = root;
  // prevXmlElement.children.add(currentXmlElement);
  while (xmlString.isNotEmpty) {
    // XML empty-element tag
    // See https://www.w3.org/TR/xml/#sec-starttags
    if (xmlString.indexOf(RegExp(r'<([s\S]*?)/>')) == 0) {
      var emptyElementTag = RegExp(r'<([s\S]*?)/>').stringMatch(xmlString);
      // print(emptyElementTag);
      currentXmlElement.setData(emptyElementTag);
      xmlString = advance(xmlString, emptyElementTag);
    // parse end tag
    } else if (xmlString.indexOf(r'</') == 0) {
      --foundStartTagCount;
      var endTag = RegExp(r'^</([\s\S]*?)>').stringMatch(xmlString);
      // print(endTag);
      var endTagLength = endTag.length;
      xmlString = advance(xmlString, endTag);
      endTag = endTag.substring(2, endTagLength - 1);
      // parse 
      var startTag = stack[stack.length - 1];
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
      // print(startTag);
    } else if (foundStartTagCount > 0) {
      // data
      var data = RegExp(r'([\s\S]*?)<').stringMatch(xmlString);
      if (data != null) {
        data = data.substring(0, data.length - 1);
        var dataLength = data.length;
        xmlString = xmlString.substring(dataLength);
        data = removeExtraSpaces(data);
        // print(data);
        currentXmlElement.setData(data.trim());
      }
    } else {
      // spaces and new lines between an ending tag and a start tag
      // TODO: Use Regex
      var i = 0;
      while (i < xmlString.length && xmlString[i] != '<') {
        ++i;
      }
      xmlString = xmlString.substring(i);
    }
  }
  // root.children.add(currentXmlElement);
  return root;
}
