import 'package:freezed_annotation/freezed_annotation.dart';

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
