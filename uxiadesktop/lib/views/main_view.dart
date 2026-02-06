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

  void goToPreviousView() {
  ValidateTokenParser response = ValidateTokenParser.fromJson({
    "status": "OK",
    "message": "S'ha tancat sessió correctament!"
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
        title: const Text("Panell de Control d'UXIA", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          Center(
            child: Text(
              "Benvingut, $_username",
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
            tooltip: "Tancar sessió",
            onPressed: () {
              goToPreviousView();
            },
          ),
          SizedBox(width: widget.bxConstraints.maxWidth / 40),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            child: Wrap(
              spacing: 32,
              runSpacing: 32,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _buildFeatureCard(
                  title: "Gestió d'Usuaris",
                  description: "Administra els usuaris del sistema.",
                  icon: Icons.people_alt_rounded,
                  color: Colors.orange[700]!,
                  onTap: () => _showInDevelopmentDialog("Gestió d'Usuaris"),
                ),
                _buildFeatureCard(
                  title: "Estadístiques de les imatges",
                  description: "Revisa els tags que les imatges a l'aplicació UXIA estan generant.",
                  icon: Icons.leaderboard,
                  color: Colors.teal[700]!,
                  onTap: () => _showInDevelopmentDialog("Configuració del Sistema"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 350,
      height: 290,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell( 
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(icon, size: 60, color: color),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color.fromARGB(255, 99, 99, 99), fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey[200]),
                Text(
                  "Prémer per obrir",
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInDevelopmentDialog(String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(featureName),
        content: const Text("Aquesta funcionalitat encara està en procés de desenvolupament."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("D'acord"),
          )
        ],
      ),
    );
  }
}