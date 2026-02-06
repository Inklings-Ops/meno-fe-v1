import 'package:equatable/equatable.dart';

final class MenoResponse<T> with EquatableMixin {
  const MenoResponse({
    this.statusCode,
    this.message,
    this.status = false,
    this.data,
    this.globalError,
    this.fieldErrors,
  });

  // We pass a decoder function 'fromJsonT' to handle the generic data.
  factory MenoResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    // A. Parse the 'error' field dynamically
    String? globalErr;
    Map<String, String>? fieldErrs;

    final errorRaw = json['error'];

    if (errorRaw is String) {
      // Case 1: error is a simple string
      globalErr = errorRaw;
    } else if (errorRaw is Map) {
      // Case 2: error is a Map of field validations
      // We safely convert generic Map to Map<String, String>
      fieldErrs = errorRaw.map((k, v) => MapEntry(k.toString(), v.toString()));
    }

    return MenoResponse(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      status: json['status'] as bool? ?? false,
      globalError: globalErr,
      fieldErrors: fieldErrs,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  final int? statusCode;
  final String? message;
  final bool status;
  final T? data;

  // If backend sends "error": "Unauthorized", this is populated
  final String? globalError;

  // If backend sends "error": {"email": "bad", "name": "bad"}
  final Map<String, String>? fieldErrors;

  /// Helper: Do we have ANY error?
  bool get hasError =>
      globalError != null || (fieldErrors?.isNotEmpty ?? false);

  @override
  List<Object?> get props => [
    statusCode,
    message,
    status,
    data,
    globalError,
    fieldErrors,
  ];
}
