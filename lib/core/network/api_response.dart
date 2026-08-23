class ApiResponse<T> {
  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  final bool success;
  final T? data;
  final String? message;
  final ApiError? error;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T? Function(Object? value)? converter,
  ) {
    return ApiResponse<T>(
      success: json['success'] == true,
      data: converter == null ? null : converter(json['data']),
      message: json['message'] as String?,
      error: json['error'] == null
          ? null
          : ApiError.fromJson(json['error'] as Map<String, dynamic>),
    );
  }
}

class ApiError {
  ApiError({this.code, this.message});

  final String? code;
  final String? message;

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] as String?,
      message: json['message'] as String?,
    );
  }
}
