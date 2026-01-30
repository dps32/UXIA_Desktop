import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {

  final BoxConstraints bxConstraints;

  const LoginView({super.key, required this.bxConstraints});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.bxConstraints.maxHeight / 2,
      width: widget.bxConstraints.maxWidth / 2,
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
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
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
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
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
                        return 'Please enter some text';
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
                            // Process data.
                          }
                        },
                        child: const Text('Log in'),
                      ),
                    ),
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