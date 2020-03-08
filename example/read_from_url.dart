import 'dart:convert';
import 'dart:io';


import 'package:spdx_xml_to_markdown/spdx_xml_to_markdown.dart';
import 'package:spdx_xml_to_markdown/src/xml_element.dart';

void main() async {
  var url = 'https://raw.githubusercontent.com/spdx/license-list-XML/master/src/MIT.xml';
  var request = await HttpClient().getUrl(Uri.parse(url));
  var response = await request.close(); 
  var xmlString = '';
  await for (var contents in response.transform(Utf8Decoder())) {
    xmlString += contents;
  }
  print(parse(xmlString));
}
