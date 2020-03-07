// Do not print alt
// Do not print optional

import 'xml_element.dart';

import 'constants.dart';

// dynamic treeToMarkdown(XmlElement root) {
//   var stack = [];
//   stack.add(root);
//   while(stack.isNotEmpty) {
//     var currentXmlElement = stack[stack.length - 1];
//     print(currentXmlElement.tag);
//     print(currentXmlElement.data);
//     // pop from stack
//     stack = stack.sublist(0, stack.length - 1);
//     for (var child in currentXmlElement.children) {
//       stack.add(child);
//     }
//   }
// }


class TreeToMarkdown {
  String markdown;
  TreeToMarkdown() {
    markdown = '';
  }
  void convert(XmlElement root) {
    treeToMarkdown(root, 0);
    print(markdown);
  }

  dynamic modifyForItem(XmlElement root) {
    if (root.tag == 'item') {
      
    }
  }

  dynamic treeToMarkdown(XmlElement root, int currentIndentation) {
    if (root.tag == 'p') {
      var modifiedText = root.data.trim();
      var toReplace = '\n';
      // TODO: Use RegEx
      for (var i = 0; i < currentIndentation; ++i) {
        toReplace += ' ';
      }
      modifiedText = modifiedText.replaceAll('\n', toReplace);
      markdown += modifiedText + '\n' + toReplace;
    } else if (root.tag == 'bullet') {
      markdown += root.data + ' ';
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
