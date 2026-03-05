// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter_it/flutter_it.dart';
// import 'package:meno/_core/_core.dart';
// import 'package:meno/features/chat/model/model.dart';
// import 'package:meno/features/chat/services/services.dart';
//
// final class ChatListManager with MLogger implements Disposable {
//   ChatListManager(this._http, this._socket);
//
//   final ChatHttpService _http;
//   final ChatSocketService _socket;
//
//   final messages = ListNotifier<Message>(data: []);
//   final isFetchingOlder = ValueNotifier(false);
//   final hasReachedEnd = ValueNotifier(false);
//
//   StreamSubscription<List<Message>>? _subscription;
//   bool _isInitialized = false;
//
//   late final initialize = Command.createAsyncNoParamNoResult(() async {
//     if (_isInitialized) return;
//     // TODO(gettoknowdavid): Await `LiveSessionManager`
//
//     await _subscription?.cancel();
//     _subscription == null;
//   }, errorFilterFn: menoExceptionFilter);
//
//   late final fetchChatMessages = Command.createAsync(
//     (int page) async {
//       final response = await _http.getMessages(broadcastId, page: page);
//
//       final json = response as Map<String, dynamic>;
//       final data = json['data'] as Map<String, dynamic>;
//       final items = data['chatMessages'] as List<dynamic>;
//       final dtos = items.map(MessageDto.fromJson).toList();
//       final domainMessages = dtos.map((e) => e.toDomain).toList();
//     },
//     initialValue: <Message>[],
//     errorFilterFn: menoExceptionFilter,
//   );
//
//   late final fetchOlderMessages = Command.createAsyncNoParamNoResult(
//     () async {
//       if (isFetchingOlder.value || !_http.canFetchMore) return;
//
//       isFetchingOlder.value = true;
//       final res = await _http.fetchOlderMessages(_session.broadcast.id);
//       return res.fold((failure) => throw failure, (_) {
//         isFetchingOlder.value = false;
//         hasReachedEnd.value = !_http.canFetchMore;
//       });
//     },
//     errorFilterFn: menoExceptionFilter,
//     restriction: isFetchingOlder.map((value) => !value),
//   );
//
//   @override
//   FutureOr<dynamic> onDispose() {}
// }
