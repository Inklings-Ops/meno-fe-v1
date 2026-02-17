import 'package:equatable/equatable.dart';
import 'package:meno/features/chat/domain/entities/message_sender.dart';
import 'package:meno/shared/domain/domain.dart';

final class MessageSenderDto with EquatableMixin {
  const MessageSenderDto({
    required this.id,
    required this.fullName,
    this.imageUrl,
  });

  factory MessageSenderDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid JSON format');
    }

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

  @override
  List<Object?> get props => [id, fullName, imageUrl];
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
