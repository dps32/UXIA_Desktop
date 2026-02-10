class FetchUsersParser {
  final String id;
  final String username;
  final String email;
  final String phone;

  FetchUsersParser(this.id, this.username, this.email, this.phone); 

  FetchUsersParser.fromJson(Map<String, dynamic> json)
    : id = json['id'] ?? '',
      username = json['username'] ?? '',
      email = json['email'] ?? '',
      phone = json['phone'] ?? '';
}