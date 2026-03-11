import 'package:meno/features/chat/model/_model.dart';

class ChatDataRepository {
  final _proxies = <String, MessageProxy>{};

  MessageProxy acquire(Message message) {
    final key = message.id.getOrCrash();
    if (_proxies.containsKey(key)) {
      _proxies[key]!.target = message;
    } else {
      _proxies[key] = MessageProxy(message);
    }
    _proxies[key]!.referenceCount++;
    return _proxies[key]!;
  }

  void release(MessageProxy proxy) {
    proxy.referenceCount--;
    if (proxy.referenceCount <= 0) {
      _proxies.remove(proxy.idStr);
      proxy.onDispose();
    }
  }

  void releaseAll(List<MessageProxy> proxies) {
    for (final proxy in proxies) {
      release(proxy);
    }
  }

  void dispose() {
    for (final proxy in _proxies.values) {
      proxy.onDispose();
    }
    _proxies.clear();
  }
}
