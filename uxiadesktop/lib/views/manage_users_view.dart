import 'package:flutter/material.dart';

class ManageUsersView extends StatefulWidget {
  const ManageUsersView({super.key});

  @override
  State<ManageUsersView> createState() => _ManageUsersViewState();
}

class _ManageUsersViewState extends State<ManageUsersView> {
  List<Map<String, dynamic>> _usersList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _usersList = List.generate(16, (index) => {
        "id": index,
        "username": "Usuari $index",
        "email": "usuari$index@uxia.com",
        "phone": "+34 123456789"
      });
      _isLoading = false;
    });
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
            icon: const Icon(Icons.person_add, color: Colors.green,),
            tooltip: "Afegir un nou usuari",
            onPressed: _isLoading ? null : _fetchUsers,
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
                        id: user["id"],
                        userName: user["username"],
                        userEmail: user["email"],
                        userPhone: user["phone"],
                        onDelete: () => _confirmDelete(user["username"]),
                      );
                    },
                  )
            ),
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
          Expanded(flex: 1, child: Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text("Nom", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text("Email", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text("Telèfon", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text("Accions", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  void _confirmDelete(String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminació"),
        content: Text("Estàs segur que vols eliminar a l'usuari $name?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel·lar")),
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Eliminar", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  final int id;
  final String userName;
  final String userEmail;
  final String userPhone;
  final VoidCallback onDelete;

  const _UserListItem({
    required this.id,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.onDelete,
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
            Expanded(flex: 1, child: Text("#$id", style: const TextStyle(color: Colors.grey, fontSize: 13))),
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
                    onPressed: () {},
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