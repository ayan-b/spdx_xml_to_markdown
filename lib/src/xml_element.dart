class XmlElement {
  String tag; // mandatory
  String data;
  Map<String, dynamic> attributes;
  Map<String, String> metaData;
  List<XmlElement> children;
  XmlElement parent; // mandatory

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
