/// XmlElement represents a node of a converted XML tree. See [parser] for
/// representation of the tree.
///
/// Consider the following XML Content:
///
/// ```xml
/// <Hello language="english">
///   Hello, World!
///   <Foo> foo! </Foo>
/// </Hello>
/// ```
///
/// `Hello` will be converted to the following XmlContent node considering it
/// is the first node of the document:
///
/// ```
/// tag: Hello
/// data: Hello, World!
/// attributes: {"language": "english"}
/// metaData: {}
/// children: [XmlElement(foo)]
/// parent: [XmlElement(root)]
/// ```
/// `foo` will be converted to:
/// ```
/// tag: Foo
/// data: foo!
/// attributes: {}
/// metaData: {}
/// children:[]
/// parent: XmlElement(Hello)
/// ```
///
/// `root` is a special node which has no data. It is the parent of the top
/// most node of the XML document.
class XmlElement {
  String tag; // required
  String data;
  Map<String, dynamic> attributes;
  Map<String, String> metaData;
  List<XmlElement> children;
  XmlElement parent; // required

  /// Concatenate to `data` if it is not null. Usefull if there are inner nodes
  /// to a XML node.
  void setData(String currentData) {
    if (data == null) {
      data = currentData;
    } else {
      data += currentData;
    }
  }

  XmlElement() {
    children = [];
  }
}
