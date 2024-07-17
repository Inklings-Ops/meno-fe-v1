import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

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

  List<VerseDto> parseVerses(dynamic data, String translation) {
    Logger().d('STARTING PARSING $translation BIBLE');
    final response = BibleResponse.fromJson(
      data,
      (p0) => (p0 as List<dynamic>)
          .map((v) => VerseDto.fromJson(v).copyWith(translation: translation))
          .toList(),
    );
    Logger().d('FINISHED PARSING $translation BIBLE');
    return response.data;
  }

  // Future<List<VerseDto>> downloadBible(
  //   String translation, {
  //   void Function(int, int)? onProgress,
  //   CancelToken? cancel,
  // }) async {
  //   Logger().d('ENTERING DOWNLOAD METHOD');

  //   try {
  //     Logger().d('STARTING DOWNLOAD OF $translation BIBLE');

  //     final dio = Dio();
  //     final uri = '${Env.bibleApiUrl}/api/default/?v=$translation';

  //     final response = await dio.get(
  //       uri,
  //       onReceiveProgress: onProgress,
  //       cancelToken: cancel,
  //     );

  //     Logger().d(response);
  //     Logger().d('FINISHED DOWNLOADING $translation BIBLE => ${response.data}');
  //     return compute((m) => parseVerses(m, translation), response.data);
  //   } on DioException catch (e) {
  //     Logger().e('ERROR INN DOWNLOAD METHOD => ${e.message}');
  //     if (e.message == null) {
  //       throw Exception('Unknown error');
  //     } else {
  //       throw Exception(e.message);
  //     }
  //   }
  // }

  // static Future<List<VerseDto>> _compute(
  //   RootIsolateToken token,
  //   String translation,
  //   void Function(int, int)? onReceiveProgress,
  // ) async {
  //   Logger().d('INSIDE DOWNLOAD ISOLATE');

  //   BackgroundIsolateBinaryMessenger.ensureInitialized(token);

  // final dio = Dio();
  // final uri = '${Env.bibleApiUrl}/api/default/?v=$translation';

  //   try {
  //     Logger().d('TRYING TO DOWNLOAD $translation FROM ISOLATE');

  //     final response = await dio.get(uri, onReceiveProgress: onReceiveProgress);

  // final bibleResponse = BibleResponse.fromJson(
  //   response.data,
  //   (p0) => (p0 as List<dynamic>).map((v) {
  //     return VerseDto.fromJson(v).copyWith(
  //       id: v['index'],
  //       translation: translation,
  //     );
  //   }).toList(),
  // );

  //     Logger().d('DONE DOWNLOADING $translation FROM ISOLATE');

  //     return bibleResponse.data;
  //   } on Exception catch (e) {
  //     throw Exception(e);
  //   }
  // }
}


// BibleResponse deserializeBibleResponsedynamic(
//   Map<String, dynamic> json,
// ) {
//   return BibleResponse.fromJson(
//     json,
//     (p0) => (p0 as List<dynamic>)
//         .map((v) => VerseDto.fromJson(v).copyWith(id: v['index']))
//         .toList(),
//   );
// }

// dynamic serializeVerses(BibleResponse<List<VerseDto>> object) {
//   return object.toJson((p0) => p0.map((e) => e.toJson()).toList());
// }
