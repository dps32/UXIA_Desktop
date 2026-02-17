import 'package:flutter/material.dart';
import 'package:uxiadesktop/main.dart';
import 'package:uxiadesktop/parsers/fetch_users_parser.dart';
import 'package:uxiadesktop/parsers/user_created_parser.dart';
import 'package:uxiadesktop/parsers/user_deleted_parser.dart';

class ManageUsersView extends StatefulWidget {
  const ManageUsersView({super.key});

  @override
  State<ManageUsersView> createState() => _ManageUsersViewState();
}

class _ManageUsersViewState extends State<ManageUsersView> {
  List<FetchUsersParser> _usersList = [];
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
  
    final dynamic data = await MainApp.data.callFetchUsers(); 

    if (data != null && data is List) {
      setState(() {
        _usersList = data.map((userJson) => FetchUsersParser.fromJson(userJson)).toList();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }
  
  Future<void> _createUser() async {
    setState(() => _isLoading = true);

    UserCreatedParser response = UserCreatedParser.fromJson(await MainApp.data.callAddUser(username: _nameController.text, email: _emailController.text, phone: _phoneController.text, password: _passwordController.text));

    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();

    if (mounted) {
      if (response.status! == "OK") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuari creat correctament")),
        );
        _fetchUsers();

        return;
      }
      else {
        final error = response.errors!.first;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al crear l'usuari: \n - $error")),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteUser(String id) async {
    setState(() => _isLoading = true);

    UserDeletedParser response = UserDeletedParser.fromJson(await MainApp.data.callDeleteUser(id: id));

    if (mounted) {
      if (response.status == "OK") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuari eliminat correctament")),
        );
        _fetchUsers();

        return;
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar a l'usuari")),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Gestió d'Usuaris", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.green),
            tooltip: "Afegir un nou usuari",
            onPressed: _isLoading ? null : _showAddUserDialog, 
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: "Refrescar llista d'usuaris",
            onPressed: _isLoading ? null : _fetchUsers,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildListHeader(),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _usersList.isEmpty 
                  ? const Center(child: Text("No hi ha usuaris disponibles."))
                  : ListView.builder(
                      itemCount: _usersList.length,
                      itemBuilder: (context, index) {
                        final user = _usersList[index];
                        return _UserListItem(
                          id: user.id,               
                          userName: user.username,
                          userEmail: user.email,
                          userPhone: user.phone,
                          onDelete: () => _confirmDelete(user.username, user.id),
                          onEdit: () => _showNotImplementedDialog(),
                        );
                      },
                    ),                  )
          ],
        ),
      ),
    );
  }

  Widget _buildListHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          SizedBox(width: 40), // Espacio del avatar
          SizedBox(width: 16),
          Expanded(flex: 3, child: Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text("Nom", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text("Email", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text("Telèfon", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text("Accions", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  void _confirmDelete(String name, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminació"),
        content: Text("Estàs segur que vols eliminar a l'usuari $name?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel·lar")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(id);
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green.withOpacity(0.1),
              radius: 28,
              child: const Icon(Icons.person_add_rounded, color: Colors.green, size: 30),
            ),
            const SizedBox(height: 16),
            const Text(
              "Nou Usuari",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const Text(
              "Introdueix les dades del nou membre",
              style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              _buildTextField(
                controller: _nameController,
                label: "Nom Complet",
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: "Correu Electrònic",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: "Telèfon",
                icon: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                label: "Contrasenya",
                icon: Icons.lock_outline,
                isPassword: true,
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              await Future.delayed(const Duration(milliseconds: 300));

              _nameController.clear();
              _emailController.clear();
              _phoneController.clear();
              _passwordController.clear();
            },
            child: const Text("Cancel·lar", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            onPressed: () async {
              if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
                Navigator.pop(context);

                await Future.delayed(const Duration(milliseconds: 300));

                _createUser();
              }
            },
            child: const Text("Crear Usuari", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showNotImplementedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              radius: 28,
              child: const Icon(Icons.construction_rounded, color: Colors.blue, size: 30),
            ),
            const SizedBox(height: 16),
            const Text(
              "Funcionalitat en camí",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: const Text(
          "L'opció de modificar usuaris encara no està disponible. Estem treballant per implementar-la ben aviat!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                elevation: 0,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Entès", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  final String id;
  final String userName;
  final String userEmail;
  final String userPhone;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _UserListItem({
    required this.id,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.onDelete,
    required this.onEdit
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFE3F2FD),
              child: Icon(Icons.person, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(flex: 3, child: Text(
              id,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,)
            ),
            Expanded(flex: 2, child: Text(userName, style: const TextStyle(fontWeight: FontWeight.w500))),
            Expanded(flex: 3, child: Text(userEmail, style: TextStyle(color: Colors.grey[600]))),
            Expanded(flex: 2, child: Text(userPhone, style: const TextStyle(fontSize: 13))),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.lightBlue, size: 20),
                    onPressed: onEdit,
                    tooltip: 'Modificar usuari',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    onPressed: onDelete,
                    tooltip: 'Eliminar usuari',
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