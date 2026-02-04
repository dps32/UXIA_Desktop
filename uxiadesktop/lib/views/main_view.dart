import 'package:flutter/material.dart';
import 'package:uxiadesktop/main.dart';
import 'package:uxiadesktop/parsers/validate_token_parser.dart';

class MainView extends StatefulWidget {
  final BoxConstraints bxConstraints;
  const MainView({super.key, required this.bxConstraints});

  @override
  State<StatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final String _username = MainApp.data.username!;
  bool _isLoading = false;

  void goToPreviousView() {
  ValidateTokenParser response = ValidateTokenParser.fromJson({
    "status": "OK",
    "message": "Log out realitzat correctament!"
  });

  final navigator = Navigator.of(context);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text("Sessió"),
        content: Text(response.message),
        actions: [
          TextButton(
            child: const Text("D'acord"),
            onPressed: () {
              Navigator.of(dialogContext).pop();

              MainApp.data.setSessionId('');
              MainApp.sd.token = null;
              MainApp.fr.saveData(MainApp.sd.url, MainApp.sd.token);

              Future.microtask(() {
                if (mounted && navigator.canPop()) {
                  navigator.pop();
                }
              });
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          Center(
            child: Text(
              "Welcome, $_username",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: const Icon(Icons.person, color: Colors.blue),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            tooltip: "Log out",
            onPressed: () {
              goToPreviousView();
            },
          ),
          SizedBox(width: widget.bxConstraints.maxWidth / 40),
        ],
      ),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(Icons.security_rounded, size: 80, color: Colors.blue[700]),
                      const SizedBox(height: 24),
                      const Text(
                        "Security Status",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Verify your current session token with the server.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.blue[700]!),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _isLoading ? null : _verifyToken,
                          icon: _isLoading 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.verified_user),
                          label: Text(_isLoading ? "Verifying..." : "Verify Token"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyToken() {
    setState(() => _isLoading = true);

    ValidateTokenParser response = ValidateTokenParser.fromJson({
      "status": "OK", 
      "message": "Token is valid"
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Session Check"),
        content: Text(response.message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (response.status != "OK") {
                goToPreviousView();
              }
            },
            child: const Text("Understand"),
          )
        ],
      ),
    );
    
    setState(() => _isLoading = false);
  }
}