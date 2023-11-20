import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_error.freezed.dart';
part 'auth_error.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  createFactory: false,
)
class AuthError with _$AuthError {
  factory AuthError({
    String? userId,
    String? email,
    String? fullName,
    String? bio,
    String? image,
    String? password,
    String? mimetype,
    String? size,
  }) = _AuthError;

  AuthError._();

  factory AuthError.fromJson(Map<String, dynamic> json) =>
      _$AuthErrorFromJson(json);

  List<String?> get props => [
        userId,
        email,
        fullName,
        bio,
        image,
        password,
        mimetype,
        size,
      ];

  bool get hasError {
    return [
      userId,
      email,
      fullName,
      bio,
      image,
      password,
      mimetype,
      size,
    ].any((prop) => prop != null);
  }
}
