// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_broadcast_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$JoinBroadcastEntity {
  String get broadcastToken => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $JoinBroadcastEntityCopyWith<JoinBroadcastEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinBroadcastEntityCopyWith<$Res> {
  factory $JoinBroadcastEntityCopyWith(
          JoinBroadcastEntity value, $Res Function(JoinBroadcastEntity) then) =
      _$JoinBroadcastEntityCopyWithImpl<$Res, JoinBroadcastEntity>;
  @useResult
  $Res call({String broadcastToken});
}

/// @nodoc
class _$JoinBroadcastEntityCopyWithImpl<$Res, $Val extends JoinBroadcastEntity>
    implements $JoinBroadcastEntityCopyWith<$Res> {
  _$JoinBroadcastEntityCopyWithImpl(this._value, this._then);

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
abstract class _$$_JoinBroadcastEntityCopyWith<$Res>
    implements $JoinBroadcastEntityCopyWith<$Res> {
  factory _$$_JoinBroadcastEntityCopyWith(_$_JoinBroadcastEntity value,
          $Res Function(_$_JoinBroadcastEntity) then) =
      __$$_JoinBroadcastEntityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String broadcastToken});
}

/// @nodoc
class __$$_JoinBroadcastEntityCopyWithImpl<$Res>
    extends _$JoinBroadcastEntityCopyWithImpl<$Res, _$_JoinBroadcastEntity>
    implements _$$_JoinBroadcastEntityCopyWith<$Res> {
  __$$_JoinBroadcastEntityCopyWithImpl(_$_JoinBroadcastEntity _value,
      $Res Function(_$_JoinBroadcastEntity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? broadcastToken = null,
  }) {
    return _then(_$_JoinBroadcastEntity(
      broadcastToken: null == broadcastToken
          ? _value.broadcastToken
          : broadcastToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_JoinBroadcastEntity implements _JoinBroadcastEntity {
  _$_JoinBroadcastEntity({required this.broadcastToken});

  @override
  final String broadcastToken;

  @override
  String toString() {
    return 'JoinBroadcastEntity(broadcastToken: $broadcastToken)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_JoinBroadcastEntity &&
            (identical(other.broadcastToken, broadcastToken) ||
                other.broadcastToken == broadcastToken));
  }

  @override
  int get hashCode => Object.hash(runtimeType, broadcastToken);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_JoinBroadcastEntityCopyWith<_$_JoinBroadcastEntity> get copyWith =>
      __$$_JoinBroadcastEntityCopyWithImpl<_$_JoinBroadcastEntity>(
          this, _$identity);
}

abstract class _JoinBroadcastEntity implements JoinBroadcastEntity {
  factory _JoinBroadcastEntity({required final String broadcastToken}) =
      _$_JoinBroadcastEntity;

  @override
  String get broadcastToken;
  @override
  @JsonKey(ignore: true)
  _$$_JoinBroadcastEntityCopyWith<_$_JoinBroadcastEntity> get copyWith =>
      throw _privateConstructorUsedError;
}
