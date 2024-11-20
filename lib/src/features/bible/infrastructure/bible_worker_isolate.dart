import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/core/env/env.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class BibleWorkerIsolate {
  BibleWorkerIsolate._(this._commands, this._responses) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  final SendPort _commands;
  final ReceivePort _responses;

  int _idCounter = 0;
  bool _isClosed = false;
  final Map<int, Completer<Object?>> _activeResponses = {};

  final Map<String, CancelToken> _cancelTokens = {};

  final _progressController = StreamController<double?>.broadcast();

  Stream<double?> get progressStream => _progressController.stream;

  Future<List<VerseDto>?> parseBible(String message) async {
    if (_isClosed) throw StateError('BibleParams is closed');
    final completer = Completer<List<VerseDto>?>.sync();
    final id = _idCounter++;
    _activeResponses[id] = completer;
    _commands.send((id, 'parse', message));
    return completer.future;
  }

  Future<List<VerseDto>?> downloadBible(String translation) async {
    if (_isClosed) throw StateError('BibleParams is closed');
    final completer = Completer<List<VerseDto>?>.sync();

    final id = _idCounter++;
    _activeResponses[id] = completer;

    final cancelToken = CancelToken();
    _cancelTokens[translation] = cancelToken;

    _commands.send((id, 'download', translation));

    return completer.future;
  }

  void _handleResponsesFromIsolate(dynamic message) {
    final (int id, Object? response) = message as (int, Object?);
    final completer = _activeResponses.remove(id)!;
    if (response is RemoteError) {
      completer.completeError(response);
    } else if (response is double?) {
      _progressController.add(response);
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
    receivePort.listen((message) async {
      if (message == 'shutdown') return receivePort.close();
      final (id, commandType, params) = message as (int, String, String);
      try {
        if (commandType == 'parse') {
          _parse(sendPort, id, params);
        } else if (commandType == 'download') {
          await _download(sendPort, id, params);
        }
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
      }
    });
  }

  static void _parse(SendPort sendPort, int id, String jsonText) {
    try {
      final jsonData = jsonDecode(jsonText) as Map<String, dynamic>;
      final res = BibleResponse.fromJson(jsonData, (bibleJson) {
        if (bibleJson is List) {
          final versesJSON = List<Map<String, dynamic>>.from(bibleJson);
          final dtos = versesJSON.map(VerseDto.fromJson).toList();
          return dtos.map((v) => v.copyWith(translation: 'kjv')).toList();
        } else {
          throw Exception('Unexpected data format in BibleResponse');
        }
      });
      sendPort.send((id, res.data));
    } catch (e) {
      sendPort.send((id, RemoteError(e.toString(), '')));
    }
  }

  static Future<void> _download(SendPort sendPort, int id, String trans) async {
    try {
      final dio = Dio();

      final uri = '${Env.bibleApiUrl}/api/default/?v=$trans';

      final response = await dio.get<dynamic>(
        uri,
        onReceiveProgress: (count, total) {
          if (total != -1) {
            final progress = count / total;
            sendPort.send((id, progress));
          }
        },
      );

      final data = response.data as Map<String, dynamic>;
      final bibleResponse = BibleResponse.fromJson(data, (bJSON) {
        if (bJSON is List) {
          final versesJSON = List<Map<String, dynamic>>.from(bJSON);
          final dtos = versesJSON.map(VerseDto.fromJson).toList();
          return dtos.map((v) => v.copyWith(translation: trans)).toList();
        } else {
          throw Exception('Unexpected data format in BibleResponse');
        }
      });

      sendPort.send((id, bibleResponse.data));
    } catch (e) {
      sendPort.send((id, RemoteError(e.toString(), '')));
    }
  }

  void cancelDownload(String translation) {
    final token = _cancelTokens.remove(translation);
    if (token != null && !token.isCancelled) {
      token.cancel('Download canceled by user');
    }
  }

  void close() {
    if (!_isClosed) {
      _isClosed = true;
      _commands.send('shutdown');
      if (_activeResponses.isEmpty) _responses.close();
      _progressController.close();
      log('BibleWorkerIsolate is closed');
    }
  }
}
