class ValidateLogoutParser {
  final String status;
  final String message;

  ValidateLogoutParser(this.status, this.message);
  
  ValidateLogoutParser.fromJson(dynamic json)
    : status = json['status'] as String,
      message = json['message'] as String;
}