// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_credentials_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserCredentialsDto _$UserCredentialsDtoFromJson(Map<String, dynamic> json) {
  return _UserCredentialsDto.fromJson(json);
}

/// @nodoc
mixin _$UserCredentialsDto {
  /// The user's DTO.
  UserDto get userDto => throw _privateConstructorUsedError;

  /// The user's token.
  String get token => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCredentialsDtoCopyWith<UserCredentialsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCredentialsDtoCopyWith<$Res> {
  factory $UserCredentialsDtoCopyWith(
          UserCredentialsDto value, $Res Function(UserCredentialsDto) then) =
      _$UserCredentialsDtoCopyWithImpl<$Res, UserCredentialsDto>;
  @useResult
  $Res call({UserDto userDto, String token});

  $UserDtoCopyWith<$Res> get userDto;
}

/// @nodoc
class _$UserCredentialsDtoCopyWithImpl<$Res, $Val extends UserCredentialsDto>
    implements $UserCredentialsDtoCopyWith<$Res> {
  _$UserCredentialsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userDto = null,
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      userDto: null == userDto
          ? _value.userDto
          : userDto // ignore: cast_nullable_to_non_nullable
              as UserDto,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserDtoCopyWith<$Res> get userDto {
    return $UserDtoCopyWith<$Res>(_value.userDto, (value) {
      return _then(_value.copyWith(userDto: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_UserCredentialsDtoCopyWith<$Res>
    implements $UserCredentialsDtoCopyWith<$Res> {
  factory _$$_UserCredentialsDtoCopyWith(_$_UserCredentialsDto value,
          $Res Function(_$_UserCredentialsDto) then) =
      __$$_UserCredentialsDtoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserDto userDto, String token});

  @override
  $UserDtoCopyWith<$Res> get userDto;
}

/// @nodoc
class __$$_UserCredentialsDtoCopyWithImpl<$Res>
    extends _$UserCredentialsDtoCopyWithImpl<$Res, _$_UserCredentialsDto>
    implements _$$_UserCredentialsDtoCopyWith<$Res> {
  __$$_UserCredentialsDtoCopyWithImpl(
      _$_UserCredentialsDto _value, $Res Function(_$_UserCredentialsDto) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userDto = null,
    Object? token = null,
  }) {
    return _then(_$_UserCredentialsDto(
      userDto: null == userDto
          ? _value.userDto
          : userDto // ignore: cast_nullable_to_non_nullable
              as UserDto,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserCredentialsDto implements _UserCredentialsDto {
  _$_UserCredentialsDto({required this.userDto, required this.token});

  factory _$_UserCredentialsDto.fromJson(Map<String, dynamic> json) =>
      _$$_UserCredentialsDtoFromJson(json);

  /// The user's DTO.
  @override
  final UserDto userDto;

  /// The user's token.
  @override
  final String token;

  @override
  String toString() {
    return 'UserCredentialsDto(userDto: $userDto, token: $token)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserCredentialsDto &&
            (identical(other.userDto, userDto) || other.userDto == userDto) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userDto, token);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserCredentialsDtoCopyWith<_$_UserCredentialsDto> get copyWith =>
      __$$_UserCredentialsDtoCopyWithImpl<_$_UserCredentialsDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserCredentialsDtoToJson(
      this,
    );
  }
}

abstract class _UserCredentialsDto implements UserCredentialsDto {
  factory _UserCredentialsDto(
      {required final UserDto userDto,
      required final String token}) = _$_UserCredentialsDto;

  factory _UserCredentialsDto.fromJson(Map<String, dynamic> json) =
      _$_UserCredentialsDto.fromJson;

  @override

  /// The user's DTO.
  UserDto get userDto;
  @override

  /// The user's token.
  String get token;
  @override
  @JsonKey(ignore: true)
  _$$_UserCredentialsDtoCopyWith<_$_UserCredentialsDto> get copyWith =>
      throw _privateConstructorUsedError;
}
