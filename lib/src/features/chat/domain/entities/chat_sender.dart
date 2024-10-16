import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_sender.freezed.dart';

@freezed
class ChatSender with _$ChatSender {
  factory ChatSender({
    required String id,
    required String fullName,
    String? imageUrl,
  }) = _ChatSender;
}
