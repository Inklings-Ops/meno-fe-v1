import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/broadcast/model/entities/broadcast_session.dart';
import 'package:meno/features/chat/model/_model.dart';
import 'package:meno/features/chat/services/_services.dart';

final class ChatListManager with MLogger implements Disposable {
  ChatListManager({
    required ChatHttpService http,
    required ChatSocketService socket,
    required BroadcastSession session,
  }) : _socket = socket,
       feed = ChatFeedSource(
         http: http,
         repository: ChatDataRepository(),
         broadcastId: session.broadcast.id,
       );

  final ChatSocketService _socket;

  /// The stable feed — widgets call `feedSource.getItemAtIndex` and watch
  /// `feedSource.itemCount`. Never replaced, only mutated.
  final ChatFeedSource feed;

  StreamSubscription<MessageDto>? _newMessageSub;
  StreamSubscription<MessageDto>? _editedMessageSub;
  StreamSubscription<MessageDto>? _deletedMessageSub;

  late final initialize = Command.createAsyncNoParamNoResult(() async {
    await _cancelStreamSubscriptions();

    _newMessageSub = _socket.onNewMessage.listen((dto) {
      log.d('ChatListManager: new message from ${dto.fullName}');
      feed.addMessageAtStart(dto.toDomain);
    });

    _editedMessageSub = _socket.onEditedMessage.listen((dto) {
      log.d('ChatListManager: edited message ${dto.id}');
      feed.updateMessage(dto.toDomain);
    });

    _deletedMessageSub = _socket.onDeletedMessage.listen((dto) {
      log.d('ChatListManager: deleted message ${dto.id}');
      feed.removeMessage(dto.id);
    });
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(feed.updateDataCommand);

  Future<void> _cancelStreamSubscriptions() async {
    await _newMessageSub?.cancel();
    await _editedMessageSub?.cancel();
    await _deletedMessageSub?.cancel();
    _newMessageSub = null;
    _editedMessageSub = null;
    _deletedMessageSub = null;
  }

  @override
  FutureOr<dynamic> onDispose() async {
    log.d('ChatListManager: disposing');
    await _cancelStreamSubscriptions();
    feed.onDispose();
    initialize.dispose();
  }
}
