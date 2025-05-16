import 'dart:async';
import 'dart:isolate';

class _IsolateMessage<T, R> {
  _IsolateMessage({
    required this.task,
    required this.input,
    required this.sendPort,
    required this.cancel,
  });

  final FutureOr<R> Function(T input) task;
  final T input;
  final SendPort sendPort;
  final bool Function() cancel;
}

class IsolateWorker<T, R> {
  IsolateWorker({required this.task});
  final FutureOr<R> Function(T input) task;

  ReceivePort? _receivePort;
  Isolate? _isolate;

  Future<R> run(T input, {required bool Function() cancel}) async {
    final completer = Completer<R>.sync();
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn<_IsolateMessage<T, R>>(
      _isolateEntryPoint,
      _IsolateMessage<T, R>(
        task: task,
        input: input,
        sendPort: _receivePort!.sendPort,
        cancel: cancel,
      ),
    );

    _receivePort!.listen((message) {
      if (message is R) {
        completer.complete(message);
        close();
      } else if (message is Exception) {
        completer.completeError(message);
        close();
      } else if (message is String && message == 'shutdown') {
        close();
      }
    });

    return completer.future;
  }

  static Future<void> _isolateEntryPoint<T, R>(
    _IsolateMessage<T, R> message,
  ) async {
    try {
      if (message.cancel()) throw Exception('Task cancelled.');
      final result = await message.task(message.input);
      message.sendPort.send(result);
    } catch (e) {
      message.sendPort.send(e);
    } finally {
      // Notify shutdown
      message.sendPort.send('shutdown');
    }
  }

  void close() {
    _receivePort?.close();
    _receivePort = null;
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }
}
