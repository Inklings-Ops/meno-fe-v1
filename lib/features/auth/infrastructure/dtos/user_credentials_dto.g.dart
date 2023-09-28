// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_credentials_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$UserCredentialsDtoToJson(UserCredentialsDto instance) =>
    <String, dynamic>{
      'userDto': instance.userDto.toJson(),
      'token': instance.token,
    };

_$_UserCredentialsDto _$$_UserCredentialsDtoFromJson(
        Map<String, dynamic> json) =>
    _$_UserCredentialsDto(
      userDto: UserDto.fromJson(json['userDto'] as Map<String, dynamic>),
      token: json['token'] as String,
    );

Map<String, dynamic> _$$_UserCredentialsDtoToJson(
        _$_UserCredentialsDto instance) =>
    <String, dynamic>{
      'userDto': instance.userDto,
      'token': instance.token,
    };
