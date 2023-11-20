import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_dto.freezed.dart';
part 'chat_dto.g.dart';

@freezed
@JsonSerializable(createFactory: false)
class ChatDto with _$ChatDto {
  factory ChatDto({
    required String id,
    required String content,
    required DateTime createdAt,
    DateTime? updatedAt,
    required String senderId,
    required String broadcastId,
  }) = _ChatDto;

  factory ChatDto.fromJson(Map<String, dynamic> json) =>
      _$ChatDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChatDtoToJson(this);
}
