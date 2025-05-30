import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginated_chat_messages.g.dart';

@JsonSerializable(genericArgumentFactories: true)
final class PaginatedChatMessages<ChatDto> with EquatableMixin {
  const PaginatedChatMessages({
    required this.chatMessages,
    required this.totalPages,
    required this.totalItems,
    required this.currentPage,
  });

  factory PaginatedChatMessages.fromJson(
    Map<String, dynamic> json,
    ChatDto Function(Object?) fromJsonT,
  ) =>
      _$PaginatedChatMessagesFromJson(json, fromJsonT);

  final List<ChatDto?> chatMessages;
  final int totalPages;
  final int totalItems;
  final int currentPage;

  @override
  List<Object?> get props => [
        chatMessages,
        totalItems,
        totalPages,
        currentPage,
      ];
}
