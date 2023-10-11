// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'broadcast_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BroadcastDto _$BroadcastDtoFromJson(Map<String, dynamic> json) {
  return _BroadcastDto.fromJson(json);
}

/// @nodoc
mixin _$BroadcastDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get broadcastToken => throw _privateConstructorUsedError;
  BroadcastStatus? get status => throw _privateConstructorUsedError;
  BroadcastCreatorDto get creator => throw _privateConstructorUsedError;
  String? get imageId => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get timeZone => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  dynamic get deleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BroadcastDtoCopyWith<BroadcastDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BroadcastDtoCopyWith<$Res> {
  factory $BroadcastDtoCopyWith(
          BroadcastDto value, $Res Function(BroadcastDto) then) =
      _$BroadcastDtoCopyWithImpl<$Res, BroadcastDto>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String? broadcastToken,
      BroadcastStatus? status,
      BroadcastCreatorDto creator,
      String? imageId,
      String? imageUrl,
      String? timeZone,
      DateTime? startTime,
      DateTime? endTime,
      DateTime? createdAt,
      dynamic deleted});

  $BroadcastCreatorDtoCopyWith<$Res> get creator;
}

/// @nodoc
class _$BroadcastDtoCopyWithImpl<$Res, $Val extends BroadcastDto>
    implements $BroadcastDtoCopyWith<$Res> {
  _$BroadcastDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? broadcastToken = freezed,
    Object? status = freezed,
    Object? creator = null,
    Object? imageId = freezed,
    Object? imageUrl = freezed,
    Object? timeZone = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? createdAt = freezed,
    Object? deleted = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      broadcastToken: freezed == broadcastToken
          ? _value.broadcastToken
          : broadcastToken // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BroadcastStatus?,
      creator: null == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as BroadcastCreatorDto,
      imageId: freezed == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      timeZone: freezed == timeZone
          ? _value.timeZone
          : timeZone // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deleted: freezed == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BroadcastCreatorDtoCopyWith<$Res> get creator {
    return $BroadcastCreatorDtoCopyWith<$Res>(_value.creator, (value) {
      return _then(_value.copyWith(creator: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_BroadcastDtoCopyWith<$Res>
    implements $BroadcastDtoCopyWith<$Res> {
  factory _$$_BroadcastDtoCopyWith(
          _$_BroadcastDto value, $Res Function(_$_BroadcastDto) then) =
      __$$_BroadcastDtoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String? broadcastToken,
      BroadcastStatus? status,
      BroadcastCreatorDto creator,
      String? imageId,
      String? imageUrl,
      String? timeZone,
      DateTime? startTime,
      DateTime? endTime,
      DateTime? createdAt,
      dynamic deleted});

  @override
  $BroadcastCreatorDtoCopyWith<$Res> get creator;
}

/// @nodoc
class __$$_BroadcastDtoCopyWithImpl<$Res>
    extends _$BroadcastDtoCopyWithImpl<$Res, _$_BroadcastDto>
    implements _$$_BroadcastDtoCopyWith<$Res> {
  __$$_BroadcastDtoCopyWithImpl(
      _$_BroadcastDto _value, $Res Function(_$_BroadcastDto) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? broadcastToken = freezed,
    Object? status = freezed,
    Object? creator = null,
    Object? imageId = freezed,
    Object? imageUrl = freezed,
    Object? timeZone = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? createdAt = freezed,
    Object? deleted = freezed,
  }) {
    return _then(_$_BroadcastDto(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      broadcastToken: freezed == broadcastToken
          ? _value.broadcastToken
          : broadcastToken // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BroadcastStatus?,
      creator: null == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as BroadcastCreatorDto,
      imageId: freezed == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      timeZone: freezed == timeZone
          ? _value.timeZone
          : timeZone // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deleted: freezed == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BroadcastDto implements _BroadcastDto {
  _$_BroadcastDto(
      {required this.id,
      required this.title,
      this.description,
      this.broadcastToken,
      this.status,
      required this.creator,
      this.imageId,
      this.imageUrl,
      this.timeZone,
      this.startTime,
      this.endTime,
      this.createdAt,
      this.deleted});

  factory _$_BroadcastDto.fromJson(Map<String, dynamic> json) =>
      _$$_BroadcastDtoFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? broadcastToken;
  @override
  final BroadcastStatus? status;
  @override
  final BroadcastCreatorDto creator;
  @override
  final String? imageId;
  @override
  final String? imageUrl;
  @override
  final String? timeZone;
  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;
  @override
  final DateTime? createdAt;
  @override
  final dynamic deleted;

  @override
  String toString() {
    return 'BroadcastDto(id: $id, title: $title, description: $description, broadcastToken: $broadcastToken, status: $status, creator: $creator, imageId: $imageId, imageUrl: $imageUrl, timeZone: $timeZone, startTime: $startTime, endTime: $endTime, createdAt: $createdAt, deleted: $deleted)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BroadcastDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.broadcastToken, broadcastToken) ||
                other.broadcastToken == broadcastToken) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.creator, creator) || other.creator == creator) &&
            (identical(other.imageId, imageId) || other.imageId == imageId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.timeZone, timeZone) ||
                other.timeZone == timeZone) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.deleted, deleted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      broadcastToken,
      status,
      creator,
      imageId,
      imageUrl,
      timeZone,
      startTime,
      endTime,
      createdAt,
      const DeepCollectionEquality().hash(deleted));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BroadcastDtoCopyWith<_$_BroadcastDto> get copyWith =>
      __$$_BroadcastDtoCopyWithImpl<_$_BroadcastDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BroadcastDtoToJson(
      this,
    );
  }
}

abstract class _BroadcastDto implements BroadcastDto {
  factory _BroadcastDto(
      {required final String id,
      required final String title,
      final String? description,
      final String? broadcastToken,
      final BroadcastStatus? status,
      required final BroadcastCreatorDto creator,
      final String? imageId,
      final String? imageUrl,
      final String? timeZone,
      final DateTime? startTime,
      final DateTime? endTime,
      final DateTime? createdAt,
      final dynamic deleted}) = _$_BroadcastDto;

  factory _BroadcastDto.fromJson(Map<String, dynamic> json) =
      _$_BroadcastDto.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get broadcastToken;
  @override
  BroadcastStatus? get status;
  @override
  BroadcastCreatorDto get creator;
  @override
  String? get imageId;
  @override
  String? get imageUrl;
  @override
  String? get timeZone;
  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;
  @override
  DateTime? get createdAt;
  @override
  dynamic get deleted;
  @override
  @JsonKey(ignore: true)
  _$$_BroadcastDtoCopyWith<_$_BroadcastDto> get copyWith =>
      throw _privateConstructorUsedError;
}
