library spdx_xml_to_markdown;

import 'src/parser.dart';
import 'src/tree_to_markdown.dart';
import 'src/xml_element.dart';

export 'src/parser.dart';
export 'src/tree_to_markdown.dart';

/// Parses an XML string and returns a markdown string.
String parse(String xmlString) {
  // Create virtual node `root`
  var root = XmlElement();
  root.tag = 'root';
  root.parent = null;
  root = parser(xmlString, root);
  var treeToMarkdown = TreeToMarkdown();
  return treeToMarkdown.convert(root);
}
