import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:meno_fe_v1/src/core/env/env.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class BibleRemoteDatasource {
  BibleRemoteDatasource({required Dio dio}) : _dio = dio;
  final Dio _dio;

  CancelToken? _cancelToken = CancelToken();

  IsolateWorker<Object?, List<VerseDto>>? _worker;

  bool get isIsolateOpen => _worker != null;

  void closeIsolate() => _worker?.close();

  Future<List<VerseDto>?> download({
    required String translation,
    required void Function(int received, int total) onProgress,
  }) async {
    try {
      final uri = '${Env.bibleApiUrl}/api/default/?v=$translation';
      final response = await _dio.get<dynamic>(
        uri,
        onReceiveProgress: onProgress,
        cancelToken: _cancelToken,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      if (response.statusCode == 200) {
        final jsonString = utf8.decode(response.data as Uint8List);
        final data = json.decode(jsonString) as Map<String, dynamic>;
        final bibleResponse = BibleResponse.fromJson(data, (bJSON) {
          if (bJSON is List) {
            final versesJSON = List<Map<String, dynamic>>.from(bJSON);
            final t = versesJSON.map(VerseDto.fromJson).toList();
            return t.map((v) => v.copyWith(translation: translation)).toList();
          } else {
            throw Exception('Unexpected data format in BibleResponse');
          }
        });
        return bibleResponse.data;
      } else {
        throw Exception('Failed to download bible.');
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) throw Exception('Download cancelled.');
      throw Exception('Download error: $e');
    } finally {
      _cancelToken = null;
    }
  }

  Future<List<VerseDto>?> parse(String jsonText, String translation) async {
    _worker = IsolateWorker(
      task: (input) {
        try {
          final jsonData = json.decode(jsonText) as Map<String, dynamic>;
          final response = BibleResponse.fromJson(jsonData, (bibleJson) {
            if (bibleJson is List) {
              final versesJSON = List<Map<String, dynamic>>.from(bibleJson);
              final dtos = versesJSON.map(VerseDto.fromJson).toList();
              return dtos
                  .map((v) => v.copyWith(translation: translation))
                  .toList();
            } else {
              throw Exception('Unexpected data format in BibleResponse');
            }
          });
          return response.data;
        } catch (e) {
          throw Exception('Failed to parse JSON file: $e');
        }
      },
    );
    return _worker!.run(jsonText, cancel: () => false);
  }

  void cancelDownload() => _cancelToken?.cancel('cancelled');
}
