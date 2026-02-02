import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uxiadesktop/main.dart';
import 'package:uxiadesktop/parsers/authentication_parser.dart';
import 'package:uxiadesktop/parsers/validate_user_parser.dart';
import 'package:uxiadesktop/views/main_view.dart';
import 'package:xml/xml.dart';

class LoginView extends StatefulWidget {

  final BoxConstraints bxConstraints;

  const LoginView({super.key, required this.bxConstraints});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _passwordVisible = false;
  bool _isLoading = false;

  void loadData() async {
    final directory = await getApplicationDocumentsDirectory();
    final fullPath = '${directory.path}/settings.xml';
    final file = File(fullPath);

    setState(() {
      _isLoading = true;
    });

    if (await file.exists()) {
      String rawContent = await file.readAsString();
      final document = XmlDocument.parse(rawContent);
      final config = document.findElements('config').first;

      final url = config.getElement('url')!.innerText;
      final token = config.getElement('token')!.innerText;

      MainApp.sd.url = url;
      _urlController.text = url;

      if (token == '') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      
      //ValidateUserParser response = ValidateUserParser.fromJson(MainApp.data.callValidateUser(token: token));
      ValidateUserParser response = ValidateUserParser.fromJson({
        "status": "NOK",
        "message": "Informació de l'usuari obtinguda correctament",
        "data": {
          "nickname": "SparkleFuzzMcGee",
          "email": "user@example.com",
          "telefon": "+34 600 000 000",
          "validat": true,
          "tos": true,
          // Opció per ampliar amb altres camps rellevants sobre l'usuari en el futur.
        }
      });

      if (response.status != "OK") {
        MainApp.sd.token = null;
        saveData(null);
        return;
      }
      
      MainApp.data.setSessionId(token);
      MainApp.data.username = response.data.nickname;

      // Pass to next view
      goToNextView();

      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  void saveData(String? token) async {
    // Save in XML URL and Token
    MainApp.sd.setUrl(_urlController.text);
    MainApp.sd.setToken(token);
    MainApp.sd.toXML();

    final directory = await getApplicationDocumentsDirectory();
    final fullPath = '${directory.path}/settings.xml';
    final file = File(fullPath);

    await file.writeAsString(MainApp.sd.toXML().toXmlString(pretty: true));
  }

  void goToNextView() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainView()),
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _urlController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2 * widget.bxConstraints.maxHeight / 3,
      width: 2 * widget.bxConstraints.maxWidth / 3,
      child: Container(
        padding: EdgeInsets.all(widget.bxConstraints.maxHeight / 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.amber
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: widget.bxConstraints.maxHeight / 16,
          children: [
            Text(
              "UXIA Management App",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0)
                      ),
                      labelText: 'Server URL',
                      suffixIcon: Icon(
                        Icons.storage_outlined,
                        semanticLabel: 'Server',
                      ),
                      hintText: 'https://your.domain.com'
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid URL';
                      }
                      return null;
                    },
                  ),
                  Padding(padding: EdgeInsetsGeometry.all(8)),
                  TextFormField(
                    controller: _userController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0)
                      ),
                      labelText: 'Username',
                      suffixIcon: Icon(
                        Icons.person,
                        semanticLabel: 'Username',
                      ),
                      hintText: 'user'
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  Padding(padding: EdgeInsetsGeometry.all(8)),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0)
                      ),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                          color: Colors.blue,
                          semanticLabel: 'Toggle password visiblity',
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      width: widget.bxConstraints.maxWidth / 8,
                      height: widget.bxConstraints.maxHeight / 16,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: WidgetStateOutlinedBorder.fromMap({
                            WidgetState.hovered | WidgetState.pressed: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16)),
                            WidgetState.any: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(0)),
                          }),
                          animationDuration: Duration(milliseconds: 375),
                          side: WidgetStateBorderSide.fromMap({
                            WidgetState.hovered: BorderSide(color: Colors.white, width: 3),
                            WidgetState.any: BorderSide(color: Colors.blueGrey, width: 1),
                          }),
                          shadowColor: WidgetStateColor.fromMap({
                            WidgetState.hovered: Colors.blueGrey.withValues(alpha: 0.5),
                            WidgetState.any: Colors.blueGrey.withValues(alpha: 0.1),
                          }),
                          backgroundColor: WidgetStateColor.fromMap({
                            WidgetState.hovered: Colors.deepOrange,
                            WidgetState.pressed: Colors.blue,
                            WidgetState.any: Colors.green
                          }),
                          textStyle: WidgetStateTextStyle.fromMap({
                            WidgetState.pressed: const TextStyle(fontWeight: FontWeight.normal),
                            WidgetState.any: const TextStyle(fontWeight: FontWeight.bold),
                          }),
                        ),
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            // Process data.
                            MainApp.data.setServerUrl(_urlController.text);
                            //AuthenticationParser response = AuthenticationParser.fromJson(MainApp.data.callAuthenticateUser(email: _userController.text, password: _passwordController.text));
                            AuthenticationParser response = AuthenticationParser.fromJson({"status": "OK", "message": "Usuari autenticat correctament", "data": {"token": "D23qswfSgR6VM9cuTuN"}});
                            
                            if (response.status != "OK") {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(response.message),
                                  );
                                },
                              );
                              setState(() {
                                _isLoading = false;
                              });
                              return;
                            }
                            
                            MainApp.data.setSessionId(response.data.token);
                            saveData(response.data.token);

                            // Pass to next View
                            goToNextView();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Log in'),
                            const Padding(padding: EdgeInsetsGeometry.all(8)),
                            const Icon(Icons.login)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Visibility(
                      visible: _isLoading, // true para mostrar, false para ocultar
                      child: Text('Connecting with Server...'),
                    ) 
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}