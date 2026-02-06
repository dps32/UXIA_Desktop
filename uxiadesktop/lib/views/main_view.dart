import 'package:flutter/material.dart';
import 'package:uxiadesktop/main.dart';
import 'package:uxiadesktop/parsers/validate_token_parser.dart';

class MainView extends StatelessWidget {
  final BoxConstraints bxConstraints;
  const MainView({super.key, required this.bxConstraints});

  // Mantenemos la lógica de cerrar sesión
  void _logout(BuildContext context) {
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
                
                if (navigator.canPop()) {
                  navigator.pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showInDevelopmentDialog(BuildContext context, String featureName) {
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

  @override
  Widget build(BuildContext context) {
    final String username = MainApp.data.username ?? "Usuari";

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
              "Benvingut, $username",
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
            onPressed: () => _logout(context),
          ),
          SizedBox(width: bxConstraints.maxWidth / 40),
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
              children: [
                FeatureCard(
                  title: "Gestió d'Usuaris",
                  description: "Administra els usuaris del sistema.",
                  icon: Icons.people_alt_rounded,
                  color: Colors.orange[700]!,
                  onTap: () => _showInDevelopmentDialog(context, "Gestió d'Usuaris"),
                ),
                FeatureCard(
                  title: "Estadístiques de les imatges",
                  description: "Revisa els tags que les imatges a l'aplicació UXIA estan generant.",
                  icon: Icons.leaderboard,
                  color: Colors.teal[700]!,
                  onTap: () => _showInDevelopmentDialog(context, "Estadístiques"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hoveredTransform = Matrix4.translationValues(0, -10, 0);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: isHovered ? hoveredTransform : Matrix4.identity(),
        width: 350,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isHovered ? 0.12 : 0.05),
              blurRadius: isHovered ? 20 : 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          color: isHovered ? Colors.white : Colors.white.withValues(alpha: 0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: isHovered ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(widget.icon, size: 60, color: widget.color),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      widget.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey[200]),
                  Text(
                    "Prémer per obrir",
                    style: TextStyle(
                      color: widget.color, 
                      fontWeight: FontWeight.bold,
                      decoration: isHovered ? TextDecoration.underline : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}