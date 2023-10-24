// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ParticipantDtoToJson(ParticipantDto instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'fullName': instance.fullName,
    'isCreator': instance.isCreator,
    'isCohost': instance.isCohost,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('imageUrl', instance.imageUrl);
  return val;
}

_$_ParticipantDto _$$_ParticipantDtoFromJson(Map<String, dynamic> json) =>
    _$_ParticipantDto(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      isCreator: json['isCreator'] as bool? ?? false,
      isCohost: json['isCohost'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$_ParticipantDtoToJson(_$_ParticipantDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'isCreator': instance.isCreator,
      'isCohost': instance.isCohost,
      'imageUrl': instance.imageUrl,
    };
