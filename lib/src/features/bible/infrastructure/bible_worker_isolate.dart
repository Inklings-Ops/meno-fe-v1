import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:meno_fe_v1/src/features/bible/bible.dart';

class BibleIsolateParams {
  const BibleIsolateParams({required this.translation});
  final String translation;
}

class BibleWorkerIsolate {
  BibleWorkerIsolate._(this._commands, this._responses) {
    _responses.listen(_handleResponsesFromIsolate);
  }
  final SendPort _commands;
  final ReceivePort _responses;

  int _idCounter = 0;
  bool _isClosed = false;
  final Map<int, Completer<Object?>> _activeResponses = {};

  Future<List<VerseDto>?> parseBible(String message) async {
    if (_isClosed) throw StateError('BibleIsolateParams is closed');
    final completer = Completer<List<VerseDto>?>.sync();
    final id = _idCounter++;
    _activeResponses[id] = completer;
    _commands.send((id, message));
    return completer.future;
  }

  Future<List<VerseDto>?> downloadBible(BibleIsolateParams params) async {
    if (_isClosed) throw StateError('BibleIsolateParams is closed');
    final completer = Completer<List<VerseDto>?>.sync();
    final id = _idCounter++;
    _activeResponses[id] = completer;
    _commands.send((id, params));
    return completer.future;
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
    rawPort.handler = (dynamic initialMessage) {
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
    _handleCommandToIsolate2(sendPort, receivePort);
  }

  // static void _handleCommandToIsolate(
  //   SendPort sendPort,
  //   ReceivePort receivePort,
  // ) {
  //   receivePort.listen((message) async {
  //     if (message == 'shutdown') return receivePort.close();
  //     final (id, params) = message as (int, BibleIsolateParams);
  //     try {
  //       final dio = Dio();
  //       final trans = params.translation;
  //       final uri = '${Env.bibleApiUrl}/api/default/?v=$trans';
  //       final response = await dio.get<dynamic>(uri);
  //       final data = response.data as Map<String, dynamic>;
  //       final bibleResponse = BibleResponse.fromJson(data, (bJSON) {
  //         if (bJSON is List) {
  //           final versesJSON = List<Map<String, dynamic>>.from(bJSON);
  //           final dtos = versesJSON.map(VerseDto.fromJson).toList();
  //           return dtos.map((v) => v.copyWith(translation: trans)).toList();
  //         } else {
  //           throw Exception('Unexpected data format in BibleResponse');
  //         }
  //       });
  //       sendPort.send((id, bibleResponse.data));
  //     } catch (e) {
  //       sendPort.send((id, RemoteError(e.toString(), '')));
  //     }
  //   });
  // }

  static void _handleCommandToIsolate2(
    SendPort sendPort,
    ReceivePort receivePort,
  ) {
    receivePort.listen((message) async {
      if (message == 'shutdown') return receivePort.close();
      final (id, jsonText) = message as (int, String);
      try {
        final jsonData = jsonDecode(jsonText) as Map<String, dynamic>;
        final bibleResponse = BibleResponse.fromJson(jsonData, (bJSON) {
          if (bJSON is List) {
            final versesJSON = List<Map<String, dynamic>>.from(bJSON);
            final dtos = versesJSON.map(VerseDto.fromJson).toList();
            return dtos.map((v) => v.copyWith(translation: 'kjv')).toList();
          } else {
            throw Exception('Unexpected data format in BibleResponse');
          }
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
