import 'xml_element.dart';

import 'constants.dart';

/// Converts a XmlElement tree to markdown. See [treeToMarkdown] for more
/// documentation.
class TreeToMarkdown {
  String markdown;
  TreeToMarkdown() {
    markdown = '';
  }

  String convert(XmlElement root) {
    treeToMarkdown(root, 0);
    return markdown;
  }

  /// Converts a tree containing `xmlElement` nodes into markdown.
  ///
  /// The data of an XML elemnt is concatenated to `markdown` string if it is
  /// of tag `<p>` or `<item>`. If a `<list>` tag is encountered the
  /// indentation is increased by two spaces. It can be modifed by changing
  /// the `INDENTATION` constant in `constants.dart` file.
  ///
  /// The markdown is built by traversing the tree in a depth-first way.
  /// See: https://en.wikipedia.org/wiki/Depth-first_search
  void treeToMarkdown(XmlElement root, int currentIndentation) {
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
