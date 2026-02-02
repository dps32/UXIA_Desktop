class AuthenticationParser {

  final int status;
  final String message;
  final Data data;

  AuthenticationParser(this.status, this.message, this.data);
  
  AuthenticationParser.fromJson(dynamic json)
    : status = json['status'] as int,
      message = json['data'] as String,
      data = json['data'] as Data;
}

class Data {
    final String token;

    Data(this.token);
  }

/*
{"status": "OK", "message": "Usuari autenticat correctament", "data": {"token": "D23qswfSgR6VM9cuTuN"}}
*/