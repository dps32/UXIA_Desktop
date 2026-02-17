class ValidateTokenParser {

  final String status;
  final String message;

  ValidateTokenParser(this.status, this.message);
  
  ValidateTokenParser.fromJson(dynamic json)
    : status = json['status'] as String,
      message = json['message'] as String;
}