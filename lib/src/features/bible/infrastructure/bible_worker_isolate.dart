import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:meno_fe_v1/src/core/env/env.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/datasources/remote/bible_response.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/dtos/dtos.dart';

class BibleIsolateParams {
  const BibleIsolateParams({required this.translation});
  final String translation;
}

class BibleWorkerIsolate {
  final SendPort _commands;
  final ReceivePort _responses;

  int _idCounter = 0;
  bool _isClosed = false;
  final Map<int, Completer<Object?>> _activeResponses = {};

  BibleWorkerIsolate._(this._commands, this._responses) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  Future<List<VerseDto>?> downloadBible(BibleIsolateParams params) async {
    if (_isClosed) throw StateError('BibleIsolateParams is closed');
    final completer = Completer<List<VerseDto>?>.sync();
    final id = _idCounter++;
    _activeResponses[id] = completer;
    _commands.send((id, params));
    return await completer.future;
  }

  void _handleResponsesFromIsolate(dynamic message) {
    final (int id, Object? response) = message as (int, Object?);
    final completer = _activeResponses.remove(id)!;
    if (response is RemoteError) {
      completer.completeError(response);
    } else {
      completer.complete(response);
    }
  }

  static Future<BibleWorkerIsolate> spawn() async {
    final rawPort = RawReceivePort();
    final completer = Completer<(SendPort, ReceivePort)>.sync();
    rawPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      final responsePort = ReceivePort.fromRawReceivePort(rawPort);
      completer.complete((commandPort, responsePort));
    };
    try {
      await Isolate.spawn(_startIsolate, rawPort.sendPort);
    } on Object catch (_) {
      rawPort.close();
      rethrow;
    }
    final (SendPort sendPort, ReceivePort receivePort) = await completer.future;
    return BibleWorkerIsolate._(sendPort, receivePort);
  }

  static void _startIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandToIsolate(sendPort, receivePort);
  }

  static void _handleCommandToIsolate(
    SendPort sendPort,
    ReceivePort receivePort,
  ) {
    receivePort.listen((message) async {
      if (message == 'shutdown') return receivePort.close();
      final (id, params) = message as (int, BibleIsolateParams);
      try {
        final dio = Dio();
        final translation = params.translation;
        final uri = '${Env.bibleApiUrl}/api/default/?v=$translation';
        final response = await dio.get(uri);
        final bibleResponse = BibleResponse.fromJson(response.data, (bJSON) {
          final versesJSON = List<Map<String, dynamic>>.from(bJSON);
          final dtos = versesJSON.map(VerseDto.fromJson).toList();
          return dtos.map((v) => v.copyWith(translation: translation)).toList();
        });
        sendPort.send((id, bibleResponse.data));
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
      }
    });
  }

  void close() {
    if (!_isClosed) {
      _isClosed = true;
      _commands.send('shutdown');
      if (_activeResponses.isEmpty) _responses.close();
      log('BibleWorkerIsolate is closed');
    }
  }
}
