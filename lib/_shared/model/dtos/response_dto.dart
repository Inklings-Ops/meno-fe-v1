import 'package:equatable/equatable.dart';

final class ResponseDto<T> with EquatableMixin {
  const ResponseDto({
    this.statusCode,
    this.message,
    this.status = false,
    this.data,
    this.error,
    this.fieldErrors,
  });

  /// Factory for parsing SUCCESS (Expects data of type T)
  factory ResponseDto.fromJson(
    dynamic json,
    T Function(Object? json) fromJsonT,
  ) => _parse(json, fromJsonT);

  /// Factory for parsing ERRORS (Ignores data, T is void)
  /// efficiently skips the generic decoder logic.
  factory ResponseDto.handleError(dynamic json) {
    return _parse(json, (_) => null);
  }

  final int? statusCode;
  final String? message;
  final bool status;
  final T? data;
  final String? error;

  /// If backend sends "error": {"email": "bad", "name": "bad"}
  final Map<String, String>? fieldErrors;

  /// Helper: Do we have ANY error?
  bool get hasError => error != null || (fieldErrors?.isNotEmpty ?? false);

  @override
  List<Object?> get props => [
    statusCode,
    message,
    status,
    data,
    error,
    fieldErrors,
  ];

  static ResponseDto<T> _parse<T>(
    dynamic json,
    T? Function(dynamic data) dataParser,
  ) {
    if (json is! Map<String, dynamic>) {
      throw FormatException(
        'Expected Map<String, dynamic> but got ${json.runtimeType}',
      );
    }

    String? globalErr;
    Map<String, String>? fieldErrs;

    final errorRaw = json['error'];

    // Dynamic Error Parsing Logic
    if (errorRaw is String) {
      globalErr = errorRaw;
    } else if (errorRaw is Map) {
      fieldErrs = {};
      for (final entry in errorRaw.entries) {
        fieldErrs[entry.key.toString()] = entry.value.toString();
      }
    }

    return ResponseDto<T>(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      status: json['status'] as bool? ?? false,
      error: globalErr,
      fieldErrors: fieldErrs,
      data: json['data'] != null ? dataParser(json['data']) : null,
    );
  }
}
