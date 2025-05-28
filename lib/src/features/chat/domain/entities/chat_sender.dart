import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/shared/shared.dart' ;

final class ChatSender with EquatableMixin {
  const ChatSender({required this.id, required this.fullName, this.imageUrl});

  final ID id;
  final SingleLineString fullName;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, fullName, imageUrl];

  ChatSender copyWith({ID? id, SingleLineString? fullName, String? imageUrl}) {
    return ChatSender(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
