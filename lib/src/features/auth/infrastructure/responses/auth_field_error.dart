import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_field_error.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class AuthFieldError extends Equatable {
  final String? fullName;
  final String? bio;
  final String? email;
  final String? password;
  final String? image;
  final String? code;
  final String? type;
  final String? mimetype;
  final String? idToken;
  final String? size;

  const AuthFieldError({
    this.fullName,
    this.bio,
    this.email,
    this.password,
    this.image,
    this.code,
    this.type,
    this.mimetype,
    this.idToken,
    this.size,
  });

  factory AuthFieldError.fromJson(Map<String, dynamic> json) =>
      _$AuthFieldErrorFromJson(json);
  @override
  List<Object?> get props => [
        fullName,
        bio,
        email,
        password,
        image,
        code,
        type,
        mimetype,
        idToken,
        size,
      ];

  Map<String, dynamic> toJson() => _$AuthFieldErrorToJson(this);
}
