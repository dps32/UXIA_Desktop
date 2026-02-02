import 'package:xml/xml.dart';

class SavedData {
  String? url;
  String? token;

  SavedData(this.url, this.token);

  factory SavedData.fromXML(XmlDocument xml) {
    final url = xml.getElement('url')!.innerText;
    final token = xml.getElement('token')!.innerText;

    return SavedData(url, token);
  }

  XmlDocument toXML() {
    final builder = XmlBuilder();

    builder.xml("<url>$url</url>");
    builder.xml("<token>$token</token>");

    return builder.buildDocument();
  }
}