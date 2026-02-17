import 'package:xml/xml.dart';

class SavedData {
  String? url;
  String? token;

  SavedData(this.url, this.token);

  void setUrl(String? url) {
    this.url = url;
  }

  void setToken(String? token) {
    this.token = token;
  }

  String? getUrl() {
    return url;
  }

  String? getToken() {
    return token;
  }

  factory SavedData.fromXML(XmlDocument xml) {
    final url = xml.getElement('url')!.innerText;
    final token = xml.getElement('token')!.innerText;

    return SavedData(url, token);
  }

  XmlDocument toXML() {
    final builder = XmlBuilder();
    builder.declaration(encoding: 'utf-8');
    builder.element('config', nest: () {
      builder.element('url', nest: url);
      builder.element('token', nest: token);
    });

    return builder.buildDocument();
  }
}