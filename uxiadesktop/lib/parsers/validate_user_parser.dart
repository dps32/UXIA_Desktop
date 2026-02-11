class ValidateUserParser {
  final String status;
  final String? message;
  final Data? data; // Ahora es opcional

  ValidateUserParser({required this.status, this.message, this.data});
  
  factory ValidateUserParser.fromJson(Map<String, dynamic> json) {
    return ValidateUserParser(
      status: json['status'] as String,
      message: json['message'] as String?,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  final String nickname;
  final String email;
  final String telefon;

  Data({required this.nickname, required this.email, required this.telefon});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      telefon: json['telefon'] as String,
    );
  }
}