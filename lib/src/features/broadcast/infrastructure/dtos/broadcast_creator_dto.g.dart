// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_creator_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$BroadcastCreatorDtoToJson(BroadcastCreatorDto instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'fullName': instance.fullName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('imageUrl', instance.imageUrl);
  return val;
}

_$_BroadcastCreatorDto _$$_BroadcastCreatorDtoFromJson(
        Map<String, dynamic> json) =>
    _$_BroadcastCreatorDto(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$_BroadcastCreatorDtoToJson(
        _$_BroadcastCreatorDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'imageUrl': instance.imageUrl,
    };
