class UserCreatedParser {
  final String? status;
  final String message;
  final List<String>? errors;

  UserCreatedParser({this.status, required this.message, this.errors});
  
  factory UserCreatedParser.fromJson(dynamic json){
    return UserCreatedParser(
      status: json['status'] as String? ?? 'Error',
      message: json['message'] as String,
      errors: json['errors'] != null 
          ? List<String>.from(json['errors']) 
          : null,
    );
  }
}