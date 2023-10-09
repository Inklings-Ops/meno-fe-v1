// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'broadcast_creator.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BroadcastCreator {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BroadcastCreatorCopyWith<BroadcastCreator> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BroadcastCreatorCopyWith<$Res> {
  factory $BroadcastCreatorCopyWith(
          BroadcastCreator value, $Res Function(BroadcastCreator) then) =
      _$BroadcastCreatorCopyWithImpl<$Res, BroadcastCreator>;
  @useResult
  $Res call({String id, String fullName, String? imageUrl});
}

/// @nodoc
class _$BroadcastCreatorCopyWithImpl<$Res, $Val extends BroadcastCreator>
    implements $BroadcastCreatorCopyWith<$Res> {
  _$BroadcastCreatorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BroadcastCreatorCopyWith<$Res>
    implements $BroadcastCreatorCopyWith<$Res> {
  factory _$$_BroadcastCreatorCopyWith(
          _$_BroadcastCreator value, $Res Function(_$_BroadcastCreator) then) =
      __$$_BroadcastCreatorCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String fullName, String? imageUrl});
}

/// @nodoc
class __$$_BroadcastCreatorCopyWithImpl<$Res>
    extends _$BroadcastCreatorCopyWithImpl<$Res, _$_BroadcastCreator>
    implements _$$_BroadcastCreatorCopyWith<$Res> {
  __$$_BroadcastCreatorCopyWithImpl(
      _$_BroadcastCreator _value, $Res Function(_$_BroadcastCreator) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_$_BroadcastCreator(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_BroadcastCreator implements _BroadcastCreator {
  const _$_BroadcastCreator(
      {required this.id, required this.fullName, this.imageUrl});

  @override
  final String id;
  @override
  final String fullName;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'BroadcastCreator(id: $id, fullName: $fullName, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BroadcastCreator &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, fullName, imageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BroadcastCreatorCopyWith<_$_BroadcastCreator> get copyWith =>
      __$$_BroadcastCreatorCopyWithImpl<_$_BroadcastCreator>(this, _$identity);
}

abstract class _BroadcastCreator implements BroadcastCreator {
  const factory _BroadcastCreator(
      {required final String id,
      required final String fullName,
      final String? imageUrl}) = _$_BroadcastCreator;

  @override
  String get id;
  @override
  String get fullName;
  @override
  String? get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$_BroadcastCreatorCopyWith<_$_BroadcastCreator> get copyWith =>
      throw _privateConstructorUsedError;
}
