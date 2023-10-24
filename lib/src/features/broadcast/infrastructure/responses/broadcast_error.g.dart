// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$BroadcastErrorToJson(BroadcastError instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('description', instance.description);
  writeNotNull('startTime', instance.startTime);
  writeNotNull('timeZone', instance.timeZone);
  writeNotNull('cohosts', instance.cohosts);
  writeNotNull('image', instance.image);
  writeNotNull('mimetype', instance.mimetype);
  writeNotNull('size', instance.size);
  val['props'] = instance.props;
  val['hasError'] = instance.hasError;
  return val;
}

_$_BroadcastError _$$_BroadcastErrorFromJson(Map<String, dynamic> json) =>
    _$_BroadcastError(
      title: json['title'] as String?,
      description: json['description'] as String?,
      startTime: json['startTime'] as String?,
      timeZone: json['timeZone'] as String?,
      cohosts: json['cohosts'] as String?,
      image: json['image'] as String?,
      mimetype: json['mimetype'] as String?,
      size: json['size'] as String?,
    );

Map<String, dynamic> _$$_BroadcastErrorToJson(_$_BroadcastError instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime,
      'timeZone': instance.timeZone,
      'cohosts': instance.cohosts,
      'image': instance.image,
      'mimetype': instance.mimetype,
      'size': instance.size,
    };
