// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_credentials_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$UserCredentialsDtoToJson(UserCredentialsDto instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'token': instance.token,
    };

_$_UserCredentialsDto _$$_UserCredentialsDtoFromJson(
        Map<String, dynamic> json) =>
    _$_UserCredentialsDto(
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$$_UserCredentialsDtoToJson(
        _$_UserCredentialsDto instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
    };
