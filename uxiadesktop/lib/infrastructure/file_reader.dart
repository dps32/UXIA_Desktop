import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uxiadesktop/main.dart';
import 'package:xml/xml.dart';

class FileReader {

  void saveData(String? url, String? token) async {
    // Save in XML URL and Token
    MainApp.sd.setUrl(url);
    MainApp.sd.setToken(token);
    MainApp.sd.toXML();

    final directory = await getApplicationDocumentsDirectory();
    final fullPath = '${directory.path}/settings.xml';
    final file = File(fullPath);

    await file.writeAsString(MainApp.sd.toXML().toXmlString(pretty: true));
  }

  Future<bool> loadData() async {
    final directory = await getApplicationDocumentsDirectory();
    final fullPath = '${directory.path}/settings.xml';
    final file = File(fullPath);
    
    bool fileRead = false;

    if (await file.exists()) {
      String rawContent = await file.readAsString();
      final document = XmlDocument.parse(rawContent);
      final config = document.findElements('config').first;

      final url = config.getElement('url')!.innerText;
      final token = config.getElement('token')!.innerText;

      MainApp.sd.url = url;

      if (token == '') {
        return fileRead;
      }

      MainApp.data.setServerUrl(url);
      MainApp.data.setSessionId(token);
      MainApp.sd.url = url;
      MainApp.sd.token = token;
      
      fileRead = true;
    }

    return fileRead;
  }
}