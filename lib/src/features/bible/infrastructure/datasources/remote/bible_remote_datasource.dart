import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';
import 'package:retrofit/retrofit.dart';

part 'bible_remote_datasource.g.dart';

@RestApi()
abstract class BibleRemoteDatasource {
  /// Creates a new `BibleRemoteDatasource` object.
  @factoryMethod
  factory BibleRemoteDatasource(
    Dio dio, {
    String baseUrl,
  }) = _BibleRemoteDatasource;

  @GET('/api/translations/')
  Future<BibleResponse<List<TranslationDto>>> getTranslations();
}
