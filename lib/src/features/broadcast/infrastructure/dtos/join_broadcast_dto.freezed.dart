// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_broadcast_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

JoinBroadcastDto _$JoinBroadcastDtoFromJson(Map<String, dynamic> json) {
  return _JoinBroadcastDto.fromJson(json);
}

/// @nodoc
mixin _$JoinBroadcastDto {
  String get broadcastToken => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JoinBroadcastDtoCopyWith<JoinBroadcastDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinBroadcastDtoCopyWith<$Res> {
  factory $JoinBroadcastDtoCopyWith(
          JoinBroadcastDto value, $Res Function(JoinBroadcastDto) then) =
      _$JoinBroadcastDtoCopyWithImpl<$Res, JoinBroadcastDto>;
  @useResult
  $Res call({String broadcastToken});
}

/// @nodoc
class _$JoinBroadcastDtoCopyWithImpl<$Res, $Val extends JoinBroadcastDto>
    implements $JoinBroadcastDtoCopyWith<$Res> {
  _$JoinBroadcastDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? broadcastToken = null,
  }) {
    return _then(_value.copyWith(
      broadcastToken: null == broadcastToken
          ? _value.broadcastToken
          : broadcastToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_JoinBroadcastDtoCopyWith<$Res>
    implements $JoinBroadcastDtoCopyWith<$Res> {
  factory _$$_JoinBroadcastDtoCopyWith(
          _$_JoinBroadcastDto value, $Res Function(_$_JoinBroadcastDto) then) =
      __$$_JoinBroadcastDtoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String broadcastToken});
}

/// @nodoc
class __$$_JoinBroadcastDtoCopyWithImpl<$Res>
    extends _$JoinBroadcastDtoCopyWithImpl<$Res, _$_JoinBroadcastDto>
    implements _$$_JoinBroadcastDtoCopyWith<$Res> {
  __$$_JoinBroadcastDtoCopyWithImpl(
      _$_JoinBroadcastDto _value, $Res Function(_$_JoinBroadcastDto) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? broadcastToken = null,
  }) {
    return _then(_$_JoinBroadcastDto(
      broadcastToken: null == broadcastToken
          ? _value.broadcastToken
          : broadcastToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_JoinBroadcastDto implements _JoinBroadcastDto {
  _$_JoinBroadcastDto({required this.broadcastToken});

  factory _$_JoinBroadcastDto.fromJson(Map<String, dynamic> json) =>
      _$$_JoinBroadcastDtoFromJson(json);

  @override
  final String broadcastToken;

  @override
  String toString() {
    return 'JoinBroadcastDto(broadcastToken: $broadcastToken)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_JoinBroadcastDto &&
            (identical(other.broadcastToken, broadcastToken) ||
                other.broadcastToken == broadcastToken));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, broadcastToken);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_JoinBroadcastDtoCopyWith<_$_JoinBroadcastDto> get copyWith =>
      __$$_JoinBroadcastDtoCopyWithImpl<_$_JoinBroadcastDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_JoinBroadcastDtoToJson(
      this,
    );
  }
}

abstract class _JoinBroadcastDto implements JoinBroadcastDto {
  factory _JoinBroadcastDto({required final String broadcastToken}) =
      _$_JoinBroadcastDto;

  factory _JoinBroadcastDto.fromJson(Map<String, dynamic> json) =
      _$_JoinBroadcastDto.fromJson;

  @override
  String get broadcastToken;
  @override
  @JsonKey(ignore: true)
  _$$_JoinBroadcastDtoCopyWith<_$_JoinBroadcastDto> get copyWith =>
      throw _privateConstructorUsedError;
}
