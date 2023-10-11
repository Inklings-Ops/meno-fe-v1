// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_field_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthFieldError _$AuthFieldErrorFromJson(Map<String, dynamic> json) =>
    AuthFieldError(
      fullName: json['fullName'] as String?,
      bio: json['bio'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      image: json['image'] as String?,
      code: json['code'] as String?,
      type: json['type'] as String?,
      mimetype: json['mimetype'] as String?,
      idToken: json['idToken'] as String?,
      size: json['size'] as String?,
    );

Map<String, dynamic> _$AuthFieldErrorToJson(AuthFieldError instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('fullName', instance.fullName);
  writeNotNull('bio', instance.bio);
  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  writeNotNull('image', instance.image);
  writeNotNull('code', instance.code);
  writeNotNull('type', instance.type);
  writeNotNull('mimetype', instance.mimetype);
  writeNotNull('idToken', instance.idToken);
  writeNotNull('size', instance.size);
  return val;
}
