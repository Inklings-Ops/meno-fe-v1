import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../dtos/dtos.dart';
import '../responses/broadcast_response.dart';

part 'broadcast_remote_datasource.g.dart';

@RestApi()
abstract class BroadcastRemoteDatasource {
  /// Creates a new `BroadcastRemoteDatasource` object.
  @factoryMethod
  factory BroadcastRemoteDatasource(
    Dio dio, {
    String baseUrl,
  }) = _BroadcastRemoteDatasource;

  @POST("/api/v1/broadcasts")
  @MultiPart()
  Future<BroadcastResponse<BroadcastDto?>> createBroadcast({
    @Part() required String title,
    @Part() String? description,
    @Part() String? timezone,
    @Part() List<String>? cohosts,
    @Part(name: 'image', contentType: 'image/png') File? image,
  });

  @DELETE("/api/v1/broadcasts/{broadcastId}")
  Future<BroadcastResponse> deleteBroadcast({
    @Path("broadcastId") required String broadcastId,
  });

  @PUT("/api/v1/broadcasts/{broadcastId}")
  @MultiPart()
  Future<BroadcastResponse<BroadcastDto?>> editBroadcast({
    @Path("broadcastId") required String broadcastId,
    @Part() String? title,
    @Part() String? description,
    @Part() String? timeZone,
    @Part() String? startTime,
    @Part() File? image,
  });

  @POST("/api/v1/broadcasts/{broadcastId}/join")
  Future<BroadcastResponse<JoinBroadcastDto?>> joinBroadcast({
    @Path("broadcastId") required String broadcastId,
  });

  @PUT("/api/v1/broadcasts/{broadcastId}/start")
  Future<BroadcastResponse<BroadcastDto?>> startBroadcast({
    @Path("broadcastId") required String broadcastId,
  });
}
