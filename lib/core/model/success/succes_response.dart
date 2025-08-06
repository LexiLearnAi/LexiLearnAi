class ApiSuccessResponse<T> {
  
  final T data;

  ApiSuccessResponse({
    
    required this.data,
  });

  factory ApiSuccessResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return ApiSuccessResponse(
      
      data: fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
