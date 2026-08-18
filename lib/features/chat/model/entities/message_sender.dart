import 'package:equatable/equatable.dart';
import 'package:meno/_core/_core.dart' show Id, SingleLineString;

final class MessageSender with EquatableMixin {
  const MessageSender({
    required this.id,
    required this.fullName,
    this.imageUrl,
  });

  final Id id;
  final SingleLineString fullName;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, fullName, imageUrl];

  MessageSender copyWith({
    Id? id,
    SingleLineString? fullName,
    String? imageUrl,
  }) {
    return MessageSender(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
