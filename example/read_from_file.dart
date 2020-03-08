import 'dart:io';

import 'package:spdx_xml_to_markdown/spdx_xml_to_markdown.dart';

void main() {
  var uri = './MIT.xml';
  var xmlString = File(uri).readAsStringSync();
  print(parse(xmlString));
}
