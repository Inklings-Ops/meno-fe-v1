// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$BroadcastDtoToJson(BroadcastDto instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'title': instance.title,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('broadcastToken', instance.broadcastToken);
  writeNotNull('status', _$BroadcastStatusEnumMap[instance.status]);
  val['creator'] = instance.creator.toJson();
  writeNotNull('imageId', instance.imageId);
  writeNotNull('imageUrl', instance.imageUrl);
  writeNotNull('timeZone', instance.timeZone);
  writeNotNull('startTime', instance.startTime?.toIso8601String());
  writeNotNull('endTime', instance.endTime?.toIso8601String());
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  writeNotNull('deleted', instance.deleted);
  return val;
}

const _$BroadcastStatusEnumMap = {
  BroadcastStatus.active: 'active',
  BroadcastStatus.inactive: 'inactive',
};

_$_BroadcastDto _$$_BroadcastDtoFromJson(Map<String, dynamic> json) =>
    _$_BroadcastDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      broadcastToken: json['broadcastToken'] as String?,
      status: $enumDecodeNullable(_$BroadcastStatusEnumMap, json['status']),
      creator:
          BroadcastCreatorDto.fromJson(json['creator'] as Map<String, dynamic>),
      imageId: json['imageId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      timeZone: json['timeZone'] as String?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      deleted: json['deleted'],
    );

Map<String, dynamic> _$$_BroadcastDtoToJson(_$_BroadcastDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'broadcastToken': instance.broadcastToken,
      'status': _$BroadcastStatusEnumMap[instance.status],
      'creator': instance.creator,
      'imageId': instance.imageId,
      'imageUrl': instance.imageUrl,
      'timeZone': instance.timeZone,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'deleted': instance.deleted,
    };
