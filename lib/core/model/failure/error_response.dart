class ErrorResponse {
  final String message;
  final String code;

  const ErrorResponse({
    required this.message,
    required this.code,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        message: json['message'] as String,
        code: json['code'] as String,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'code': code,
      };
}

