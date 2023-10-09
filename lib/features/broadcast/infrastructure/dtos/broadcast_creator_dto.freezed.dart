// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'broadcast_creator_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BroadcastCreatorDto _$BroadcastCreatorDtoFromJson(Map<String, dynamic> json) {
  return _BroadcastCreatorDto.fromJson(json);
}

/// @nodoc
mixin _$BroadcastCreatorDto {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BroadcastCreatorDtoCopyWith<BroadcastCreatorDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BroadcastCreatorDtoCopyWith<$Res> {
  factory $BroadcastCreatorDtoCopyWith(
          BroadcastCreatorDto value, $Res Function(BroadcastCreatorDto) then) =
      _$BroadcastCreatorDtoCopyWithImpl<$Res, BroadcastCreatorDto>;
  @useResult
  $Res call({String id, String fullName, String? imageUrl});
}

/// @nodoc
class _$BroadcastCreatorDtoCopyWithImpl<$Res, $Val extends BroadcastCreatorDto>
    implements $BroadcastCreatorDtoCopyWith<$Res> {
  _$BroadcastCreatorDtoCopyWithImpl(this._value, this._then);

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
abstract class _$$_BroadcastCreatorDtoCopyWith<$Res>
    implements $BroadcastCreatorDtoCopyWith<$Res> {
  factory _$$_BroadcastCreatorDtoCopyWith(_$_BroadcastCreatorDto value,
          $Res Function(_$_BroadcastCreatorDto) then) =
      __$$_BroadcastCreatorDtoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String fullName, String? imageUrl});
}

/// @nodoc
class __$$_BroadcastCreatorDtoCopyWithImpl<$Res>
    extends _$BroadcastCreatorDtoCopyWithImpl<$Res, _$_BroadcastCreatorDto>
    implements _$$_BroadcastCreatorDtoCopyWith<$Res> {
  __$$_BroadcastCreatorDtoCopyWithImpl(_$_BroadcastCreatorDto _value,
      $Res Function(_$_BroadcastCreatorDto) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_$_BroadcastCreatorDto(
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
@JsonSerializable()
class _$_BroadcastCreatorDto implements _BroadcastCreatorDto {
  _$_BroadcastCreatorDto(
      {required this.id, required this.fullName, this.imageUrl});

  factory _$_BroadcastCreatorDto.fromJson(Map<String, dynamic> json) =>
      _$$_BroadcastCreatorDtoFromJson(json);

  @override
  final String id;
  @override
  final String fullName;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'BroadcastCreatorDto(id: $id, fullName: $fullName, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BroadcastCreatorDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, fullName, imageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BroadcastCreatorDtoCopyWith<_$_BroadcastCreatorDto> get copyWith =>
      __$$_BroadcastCreatorDtoCopyWithImpl<_$_BroadcastCreatorDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BroadcastCreatorDtoToJson(
      this,
    );
  }
}

abstract class _BroadcastCreatorDto implements BroadcastCreatorDto {
  factory _BroadcastCreatorDto(
      {required final String id,
      required final String fullName,
      final String? imageUrl}) = _$_BroadcastCreatorDto;

  factory _BroadcastCreatorDto.fromJson(Map<String, dynamic> json) =
      _$_BroadcastCreatorDto.fromJson;

  @override
  String get id;
  @override
  String get fullName;
  @override
  String? get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$_BroadcastCreatorDtoCopyWith<_$_BroadcastCreatorDto> get copyWith =>
      throw _privateConstructorUsedError;
}
