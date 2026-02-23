import 'package:flutter/material.dart';
import 'package:uxiadesktop/main.dart';
import 'package:uxiadesktop/parsers/authentication_parser.dart';
import 'package:uxiadesktop/parsers/validate_user_parser.dart';
import 'package:uxiadesktop/views/main_view.dart';

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
    final result = await MainApp.fr.loadData();
    if (!result) {
      _urlController.text = MainApp.sd.url ?? '';
      return;
    }

    setState(() => _isLoading = true);

    validateUser();
  }

  Future<void> validateUser() async {
    final rawResponse = await MainApp.data.callValidateUser();
    ValidateUserParser response = ValidateUserParser.fromJson(rawResponse);

    if (response.status != "OK") {
      MainApp.sd.token = null;
      MainApp.fr.saveData(MainApp.sd.url, null);
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuari amb un token erroni")),
        );
      }
      return;
    }
    
    MainApp.data.setSessionId(MainApp.sd.token!);
    MainApp.data.username = response.data?.nickname;
    goToNextView();
  }

  void goToNextView() {
    setState(() => _isLoading = false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainView(bxConstraints: widget.bxConstraints)),
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didUpdateWidget(covariant LoginView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _urlController.text = MainApp.sd.url ?? '';
    _userController.text = '';
    _passwordController.text = '';
  }

  @override
  void dispose() {
    _urlController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_balance_wallet, size: 64, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  "Gestió d'UXIA",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("Si us plau, logueja\'t per a continuar", style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _urlController,
                        label: 'URL del servidor',
                        icon: Icons.dns_outlined,
                        hint: 'el.teu.domini.com',
                        isURL: true
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _userController,
                        label: 'Email',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Contrasenya',
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _isLoading ? null : _handleLogin,
                          child: _isLoading 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Logueja\'t', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    bool isPassword = false,
    bool isURL = false
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_passwordVisible,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: isURL ? 'https://' : null,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: isPassword 
          ? IconButton(
              icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
            )
          : null,
      ),
      validator: (value) => (value == null || value.isEmpty) ? 'Camp obligatori' : null,
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      MainApp.data.setServerUrl(_urlController.text);
      
      final rawResponse = await MainApp.data.callAuthenticateUser(
        email: _userController.text, 
        password: _passwordController.text
      );

      AuthenticationParser response = AuthenticationParser.fromJson(rawResponse);

      if (response.status.toUpperCase() != "OK") {
        if (mounted) {
          showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(response.message),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
          ),
        );
        }
        setState(() => _isLoading = false);
        return;
      }
      
      MainApp.data.setSessionId(response.data.token);
      MainApp.fr.saveData(MainApp.sd.url, response.data.token);

      validateUser();
    }
  }
}