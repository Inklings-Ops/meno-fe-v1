import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';

part 'participant_dto.freezed.dart';
part 'participant_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class ParticipantDto with _$ParticipantDto {
  factory ParticipantDto({
    required String id,
    required String fullName,
    @Default(false) bool isCreator,
    @Default(false) bool isCohost,
    String? imageUrl,
  }) = _ParticipantDto;

  factory ParticipantDto.fromJson(Map<String, dynamic> json) =>
      _$ParticipantDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ParticipantDtoToJson(this);
}

extension ParticipantDtoToDomain on ParticipantDto {
  Participant get toDomain => Participant(
        id: id,
        fullName: fullName,
        imageUrl: imageUrl,
        isCreator: isCreator,
        isCohost: isCohost,
      );
}

extension ParticipantToDto on Participant {
  ParticipantDto get toDto => ParticipantDto(
        id: id,
        fullName: fullName,
        imageUrl: imageUrl,
        isCreator: isCreator,
        isCohost: isCohost,
      );
}
