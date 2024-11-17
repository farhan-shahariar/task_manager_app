class NetworkResponse {
  final int statusCode;
  final bool isSuccess;
  final dynamic responseData;
  final String? errorMessage;
  final String? status;

  NetworkResponse({
    required this.statusCode,
    required this.isSuccess,
    this.responseData,
    this.errorMessage,
    this.status,
  });
}
