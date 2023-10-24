// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ParticipantDto _$ParticipantDtoFromJson(Map<String, dynamic> json) {
  return _ParticipantDto.fromJson(json);
}

/// @nodoc
mixin _$ParticipantDto {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  bool get isCreator => throw _privateConstructorUsedError;
  bool get isCohost => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ParticipantDtoCopyWith<ParticipantDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantDtoCopyWith<$Res> {
  factory $ParticipantDtoCopyWith(
          ParticipantDto value, $Res Function(ParticipantDto) then) =
      _$ParticipantDtoCopyWithImpl<$Res, ParticipantDto>;
  @useResult
  $Res call(
      {String id,
      String fullName,
      bool isCreator,
      bool isCohost,
      String? imageUrl});
}

/// @nodoc
class _$ParticipantDtoCopyWithImpl<$Res, $Val extends ParticipantDto>
    implements $ParticipantDtoCopyWith<$Res> {
  _$ParticipantDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? isCreator = null,
    Object? isCohost = null,
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
      isCreator: null == isCreator
          ? _value.isCreator
          : isCreator // ignore: cast_nullable_to_non_nullable
              as bool,
      isCohost: null == isCohost
          ? _value.isCohost
          : isCohost // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ParticipantDtoCopyWith<$Res>
    implements $ParticipantDtoCopyWith<$Res> {
  factory _$$_ParticipantDtoCopyWith(
          _$_ParticipantDto value, $Res Function(_$_ParticipantDto) then) =
      __$$_ParticipantDtoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String fullName,
      bool isCreator,
      bool isCohost,
      String? imageUrl});
}

/// @nodoc
class __$$_ParticipantDtoCopyWithImpl<$Res>
    extends _$ParticipantDtoCopyWithImpl<$Res, _$_ParticipantDto>
    implements _$$_ParticipantDtoCopyWith<$Res> {
  __$$_ParticipantDtoCopyWithImpl(
      _$_ParticipantDto _value, $Res Function(_$_ParticipantDto) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? isCreator = null,
    Object? isCohost = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_$_ParticipantDto(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      isCreator: null == isCreator
          ? _value.isCreator
          : isCreator // ignore: cast_nullable_to_non_nullable
              as bool,
      isCohost: null == isCohost
          ? _value.isCohost
          : isCohost // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ParticipantDto implements _ParticipantDto {
  _$_ParticipantDto(
      {required this.id,
      required this.fullName,
      this.isCreator = false,
      this.isCohost = false,
      this.imageUrl});

  factory _$_ParticipantDto.fromJson(Map<String, dynamic> json) =>
      _$$_ParticipantDtoFromJson(json);

  @override
  final String id;
  @override
  final String fullName;
  @override
  @JsonKey()
  final bool isCreator;
  @override
  @JsonKey()
  final bool isCohost;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'ParticipantDto(id: $id, fullName: $fullName, isCreator: $isCreator, isCohost: $isCohost, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ParticipantDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.isCreator, isCreator) ||
                other.isCreator == isCreator) &&
            (identical(other.isCohost, isCohost) ||
                other.isCohost == isCohost) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, fullName, isCreator, isCohost, imageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ParticipantDtoCopyWith<_$_ParticipantDto> get copyWith =>
      __$$_ParticipantDtoCopyWithImpl<_$_ParticipantDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ParticipantDtoToJson(
      this,
    );
  }
}

abstract class _ParticipantDto implements ParticipantDto {
  factory _ParticipantDto(
      {required final String id,
      required final String fullName,
      final bool isCreator,
      final bool isCohost,
      final String? imageUrl}) = _$_ParticipantDto;

  factory _ParticipantDto.fromJson(Map<String, dynamic> json) =
      _$_ParticipantDto.fromJson;

  @override
  String get id;
  @override
  String get fullName;
  @override
  bool get isCreator;
  @override
  bool get isCohost;
  @override
  String? get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$_ParticipantDtoCopyWith<_$_ParticipantDto> get copyWith =>
      throw _privateConstructorUsedError;
}
