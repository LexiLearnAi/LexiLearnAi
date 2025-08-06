class BaseResponse<T> {
  final ResponseInfo response;
  final T data;

  BaseResponse({required this.response, required this.data});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      response: ResponseInfo.fromJson(json['response']),
      data: json['data'],
    );
  }
}

class ResponseInfo {
  final int code;
  final String message;
  final String path;

  ResponseInfo({required this.code, required this.message, required this.path});

  factory ResponseInfo.fromJson(Map<String, dynamic> json) {
    return ResponseInfo(
      code: json['code'],
      message: json['message'],
      path: json['path'],
    );
  }
}