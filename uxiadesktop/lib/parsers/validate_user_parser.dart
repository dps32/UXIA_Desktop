class ValidateUserParser {
  final String status;
  final String message;
  final Data data;

  ValidateUserParser(this.status, this.message, this.data);
  
  ValidateUserParser.fromJson(dynamic json)
    : status = json['status'] as String,
      message = json['message'] as String,
      data = Data.fromJson(json['data']);
}

class Data {
    final String nickname;
    final String email;
    final String telefon;
    final bool validat;
    final bool tos;

    Data(this.nickname, this.email, this.telefon, this.validat, this.tos);

    Data.fromJson(dynamic json)
      : nickname = json['nickname'] as String,
        email = json['email'] as String,
        telefon = json['telefon'] as String,
        validat = json['validat'] as bool,
        tos = json['tos'] as bool;
  }