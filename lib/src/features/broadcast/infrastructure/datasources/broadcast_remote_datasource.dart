import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:retrofit/retrofit.dart';

part 'broadcast_remote_datasource.g.dart';

@RestApi()
abstract class BroadcastRemoteDatasource {
  /// Creates a new `BroadcastRemoteDatasource` object.
  @factoryMethod
  factory BroadcastRemoteDatasource(
    Dio dio, {
    String baseUrl,
  }) = _BroadcastRemoteDatasource;

  @POST('/api/v1/broadcasts')
  @MultiPart()
  Future<BroadcastResponse<BroadcastDto?>> createBroadcast({
    @Part() required String title,
    @Part() String? description,
    @Part() String? timezone,
    @Part() List<String>? cohosts,
    @Part(name: 'image', contentType: 'image/png') File? image,
  });

  @DELETE('/api/v1/broadcasts/{broadcastId}')
  Future<BroadcastResponse<dynamic>> deleteBroadcast({
    @Path('broadcastId') required String broadcastId,
  });

  @PUT('/api/v1/broadcasts/{broadcastId}')
  @MultiPart()
  Future<BroadcastResponse<BroadcastDto?>> editBroadcast({
    @Path('broadcastId') required String broadcastId,
    @Part() String? title,
    @Part() String? description,
    @Part() String? timeZone,
    @Part() String? startTime,
    @Part() File? image,
  });

  @POST('/api/v1/broadcasts/{broadcastId}/join')
  Future<BroadcastResponse<JoinBroadcastDto?>> joinBroadcast({
    @Path('broadcastId') required String broadcastId,
  });

  @PUT('/api/v1/broadcasts/{broadcastId}/start')
  Future<BroadcastResponse<BroadcastDto?>> startBroadcast({
    @Path('broadcastId') required String broadcastId,
  });

  @GET('/api/v1/broadcasts/')
  Future<BroadcastResponse<BroadcastListDto?>> getBroadcasts({
    /// Status of the broadcast
    /// Example : active or inactive
    @Query('status') String? status,

    /// Adds an extra field to each broadcast response with the number of
    /// listeners that tuned in
    ///
    /// Example : totalListeners
    @Query('include') String? include,

    /// Returns only broadcasts of accounts the logged In user is subscribed to
    @Query('onlySubscriptions') bool? onlySubscriptions,

    /// Searches for broadcasts and creators that match that keyword
    @Query('keywords') String? keywords,

    /// Return only broadcasts created by a specific user
    @Query('creatorId') String? creatorId,

    /// Sort by a specific broadcast field
    @Query('sortBy') String? sortBy,

    /// Order by a specific broadcast field
    /// Example : ASC or DESC
    @Query('orderBy') String? orderBy,

    /// Used for pagination
    @Query('page') int? page,

    /// Used for pagination
    @Query('size') int? size,

    /// End time
    @Query('endTime') String? endTime,

    /// Greater than end time
    @Query('endTime[gt]') String? endTimeGT,

    /// Less than end time
    @Query('endTime[lt]') String? endTimeLT,

    /// Equal to end time
    @Query('endTime[exist]') bool? endTimeExist,

    /// Start time
    @Query('startTime') String? startTime,

    /// Greater than start time
    @Query('startTime[gt]') String? startTimeGT,

    /// Less than start time
    @Query('startTime[lt]') String? startTimeLT,

    /// Equal to start time
    @Query('startTime[exist]') bool? startTimeExist,
  });
}
