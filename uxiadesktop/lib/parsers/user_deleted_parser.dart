class UserDeletedParser {
  final String status;
  final String message;

  UserDeletedParser({required this.status, required this.message});
  
  factory UserDeletedParser.fromJson(dynamic json){
    return UserDeletedParser(
      status: json['status'] as String,
      message: json['message'] as String,
    );
  }
}