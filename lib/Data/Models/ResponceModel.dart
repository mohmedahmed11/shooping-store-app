class ResponseModel {
  final bool status;
  final dynamic data;
  final String? message;
  ResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      status: json['status'],
      data: json['data'],
      message: json['message'],
    );
  }
}
