import 'xml_element.dart';

import 'constants.dart';

class TreeToMarkdown {
  String markdown;
  TreeToMarkdown() {
    markdown = '';
  }

  String convert(XmlElement root) {
    treeToMarkdown(root, 0);
    return markdown;
  }

  dynamic treeToMarkdown(XmlElement root, int currentIndentation) {
    if (root.tag == 'p' || root.tag == 'item') {
      var modifiedText = root.data.trim();
      var toReplace = '\n';
      for (var i = 0; i < currentIndentation; ++i) {
        toReplace += ' ';
      }
      modifiedText = modifiedText.replaceAll('\n', toReplace);
      markdown += modifiedText + '\n' + toReplace;
    }

    if (root.tag == 'list') {
      currentIndentation += INDENTATION;
    }
    for (var child in root.children) {
      treeToMarkdown(child, currentIndentation);
    }
    if (root.tag == 'list') {
      currentIndentation -= INDENTATION;
    }
  }
}
