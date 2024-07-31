import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/discover/infrastructure/discover_response.dart';
import 'package:meno_fe_v1/src/features/discover/infrastructure/dtos/discover_result_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'discover_remote_datasource.g.dart';

@RestApi()
abstract class DiscoverRemoteDatasource {
  @factoryMethod
  factory DiscoverRemoteDatasource(Dio dio, {String baseUrl}) =
      _DiscoverRemoteDatasource;

  @GET('/api/v1/broadcasts/')
  Future<DiscoverResponse<DiscoverResultDto?>> search({
    @Query('keywords') String? keywords,
    @Query('include') String? include = 'totalListeners',
    @Query('sortBy') String? sortBy,
    @Query('orderBy') String? orderBy,
    @Query('page') int? page,
    @Query('size') int? size,
  });

  @GET('/api/v1/broadcasts/')
  Future<DiscoverResponse<DiscoverResultDto?>> fetchNowLive({
    @Query('sortBy') String? sortBy,
    @Query('orderBy') String? orderBy,
    @Query('include') String? include = 'totalListeners',
    @Query('page') int? page,
    @Query('size') int? size,
    @Query('endTime[eq]') String? endTime,
  });

  @GET('/api/v1/broadcasts/')
  Future<DiscoverResponse<DiscoverResultDto?>> fetchRecentlyLive({
    @Query('sortBy') String? sortBy,
    @Query('orderBy') String? orderBy,
    @Query('include') String? include = 'totalListeners',
    @Query('page') int? page,
    @Query('size') int? size,
    @Query('endTime[gt]') String? endTimeGT,
    @Query('endTime[lt]') String? endTimeLT,
  });

  @GET('/api/v1/broadcasts/')
  Future<DiscoverResponse<DiscoverResultDto?>> fetchBroadcasts({
    @Query('status') String? status,
    @Query('include') String? include = 'totalListeners',
    @Query('onlySubscriptions') bool? onlySubscriptions,
    @Query('keywords') String? keywords,
    @Query('creatorId') String? creatorId,
    @Query('sortBy') String? sortBy,
    @Query('orderBy') String? orderBy,
    @Query('page') int? page,
    @Query('size') int? size,
    @Query('endTime') String? endTime,
    @Query('endTime[gt]') String? endTimeGT,
    @Query('endTime[lt]') String? endTimeLT,
    @Query('startTime') String? startTime,
    @Query('startTime[gt]') String? startTimeGT,
    @Query('startTime[lt]') String? startTimeLT,
  });
}
