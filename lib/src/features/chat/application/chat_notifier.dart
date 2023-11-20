import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/domain.dart';

part 'chat_notifier.g.dart';

@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  List<Chat?> build() => _chats;

  void post(Chat chat) {
    final previousState = state;
    state = [chat, ...previousState];
  }
}

final _chats = [
  Chat(
    // knowdavidmichael@gmail.com
    id: "1",
    content: IChatContent(
      "'For the wages of sin is death, but the free gift of God is eternal life through Christ Jesus our Lord.' Romans 6:23 NLT",
    ),
    createdAt: DateTime.now(),
    senderId: "3e43bf4d-7ab1-4d30-92d7-02fedf2d5ed1",
    broadcastId: "broadcast1",
  ),
  Chat(
    // dainibayo@gmail.com
    id: "2",
    content: IChatContent("I see myself in the finished works of Christ!"),
    createdAt: DateTime.now(),
    senderId: "e286c60c-44f9-4c75-aa37-b37cacb08f0f",
    broadcastId: "broadcast1",
  ),
  Chat(
    // prdmike@gmail.com
    id: "3",
    content: IChatContent("That's the testimony of my life! 🤸‍♀️🤸‍♀️"),
    createdAt: DateTime.now(),
    senderId: "6fe8dbf2-e0ec-4d8c-bb13-fb9583cda788",
    broadcastId: "broadcast1",
  ),
];
