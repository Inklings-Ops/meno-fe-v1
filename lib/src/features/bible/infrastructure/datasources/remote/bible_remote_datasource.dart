import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../../../../../core/env/env.dart';
import '../../dtos/dtos.dart';
import '../data_helper.dart';
import 'bible_response.dart';

class BibleRemoteDatasource {
  final Dio _dio;
  final String _baseUrl;

  BibleRemoteDatasource(
    Dio dio, {
    required String baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  Future<BibleResponse<List<TranslationDto>>> getTranslations() async {
    try {
      final response = await _dio.get('$_baseUrl/api/translations');
      // final bibleResponse = BibleResponse.fromJson(
      //   response.data,
      //   (p0) => (p0 as List<dynamic>)
      //       .cast<Map<String, dynamic>>()
      //       .map(TranslationDto.fromJson)
      //       .toList(),
      // );

      final data = response.data as Map<String, dynamic>;

      final List<String> stringList = data['data'].cast<String>();

      final translations = stringList.map(handleFullTranslations).toList();
      return BibleResponse<List<TranslationDto>>(data: translations);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<List<VerseDto>> downloadBible(String translation) async {
    RootIsolateToken token = RootIsolateToken.instance!;
    final result = await _compute(token, translation);
    return result;
  }

  static Future<List<VerseDto>> _compute(
    RootIsolateToken token,
    String translation,
  ) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);

    final dio = Dio();
    final uri = '${Env.bibleApiUrl}/api/default/?v=$translation';

    try {
      final response = await dio.get(uri);

      final bibleResponse = BibleResponse.fromJson(
        response.data,
        (p0) => (p0 as List<dynamic>)
            .map((v) => VerseDto.fromJson(v).copyWith(id: v['index']))
            .toList(),
      );

      return bibleResponse.data;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}

BibleResponse deserializeBibleResponsedynamic(
  Map<String, dynamic> json,
) {
  return BibleResponse.fromJson(
    json,
    (p0) => (p0 as List<dynamic>)
        .map((v) => VerseDto.fromJson(v).copyWith(id: v['index']))
        .toList(),
  );
}

dynamic serializeVerses(BibleResponse<List<VerseDto>> object) {
  return object.toJson((p0) => p0.map((e) => e.toJson()).toList());
}
