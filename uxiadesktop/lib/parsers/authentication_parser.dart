class AuthenticationParser {

  final String status;
  final String message;
  final Data data;

  AuthenticationParser(this.status, this.message, this.data);
  
  AuthenticationParser.fromJson(dynamic json)
    : status = json['status'] as String,
      message = json['message'] as String,
      data = Data.fromJson(json['data']);
}

class Data {
    final String token;

    Data(this.token);

    Data.fromJson(dynamic json)
      : token = json['token'] as String;
  }