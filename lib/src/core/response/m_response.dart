// ignore_for_file: inference_failure_on_instance_creation

import 'package:freezed_annotation/freezed_annotation.dart';

part 'm_response.freezed.dart';
part 'm_response.g.dart';

/// A sealed union class representing a network response.
///
/// This class provides a structured way to represent the outcome of a network
/// request, either successful (`MResponseData`) or containing an error
/// (`MResponseError`). This can help improve type safety and make your
/// code more readable by explicitly handling different response scenarios.
@Freezed(genericArgumentFactories: true)
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
sealed class MResponse<T> with _$MResponse<T> {
  /// A successful response containing data and optional information.
  ///
  /// This constructor represents a successful network response with optional
  /// details like status code, message, request path, and a boolean flag
  /// indicating success.
  const factory MResponse.data({
    /// The parsed data from the response.
    @MRConverter() T? data,

    /// The HTTP status code of the response.
    int? statusCode,

    /// An optional message associated with the response.
    String? message,

    /// The requested path or endpoint for the response.
    String? path,

    /// A boolean flag indicating success or failure.
    bool? status,
  }) = MResponseData;

  /// An error response containing error details and optional information.
  ///
  /// This constructor represents an error response from the network with
  /// optional details like status code, message, request path, and a boolean
  /// flag indicating success.
  const factory MResponse.error({
    /// The parsed error data from the response.
    @MRConverter() T? error,

    /// The HTTP status code of the response.
    int? statusCode,

    /// An optional message associated with the error response.
    String? message,

    /// The requested path or endpoint for the response.
    String? path,

    /// A boolean flag indicating success or failure (usually `false`).
    bool? status,
  }) = MResponseError;

  /// Creates an MResponse instance from a JSON map.
  ///
  /// This factory constructor is used by the `JsonSerializable` package
  /// to deserialize JSON data into an `MResponse` object. It requires a
  /// function to convert the generic type `T` from a JSON object.
  factory MResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$MResponseFromJson(json, fromJsonT);
}

/// A custom JSON converter for the generic type `T` in `MResponse`.
///
/// This converter handles deserialization of the generic data or error based
/// on the presence of keys like "data" and "error" in the JSON payload. It
/// also filters out any key named "runtimeType".
class MRConverter<T> implements JsonConverter<T?, Map<String, dynamic>> {
  const MRConverter();

  @override
  T? fromJson(Map<String, dynamic> json) {
    if (json['runtimeType'] != null) {
      return null;
    }

    if (json['error'] != null) {
      return json['error'] as T?;
    }

    return json['data'] as T?;
  }

  @override
  Map<String, dynamic> toJson(T? data) => throw UnimplementedError();
}
