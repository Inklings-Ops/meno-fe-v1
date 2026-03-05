import 'package:meno/_core/_core.dart' show FormatError, Id, SingleLineString;
import 'package:meno/features/chat/model/entities/message_sender.dart';

final class MessageSenderDto {
  const MessageSenderDto({
    required this.id,
    required this.fullName,
    this.imageUrl,
  });

  factory MessageSenderDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw FormatError<MessageSenderDto>();
    return MessageSenderDto(
      id: json[_kId] as String,
      fullName: json[_kFullName] as String,
      imageUrl: json[_kImageUrl] as String?,
    );
  }

  final String id;
  final String fullName;
  final String? imageUrl;

  static const String _kId = 'id';
  static const String _kFullName = 'fullName';
  static const String _kImageUrl = 'imageUrl';

  Map<String, dynamic> toJson() => {
    _kId: id,
    _kFullName: fullName,
    _kImageUrl: imageUrl,
  };
}

extension MessageSenderToDtoX on MessageSender {
  MessageSenderDto get toDto {
    return MessageSenderDto(
      id: id.getOrCrash(),
      fullName: fullName.getOrCrash(),
      imageUrl: imageUrl,
    );
  }
}

extension MessageSenderToDomainX on MessageSenderDto {
  MessageSender get toDomain {
    return MessageSender(
      id: Id.fromString(id),
      fullName: SingleLineString(fullName),
      imageUrl: imageUrl,
    );
  }
}
