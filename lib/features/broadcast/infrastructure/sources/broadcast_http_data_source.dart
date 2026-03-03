import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/infrastructure/infrastructure.dart';

class BroadcastHttpDataSource with MLogger {
  const BroadcastHttpDataSource(this._client);

  final ApiClient _client;

  Future<BroadcastDto?> createBroadcast({
    required String title,
    required String description,
    String? timezone,
    List<String>? cohosts,
    File? image,
    CancelToken? cancelToken,
  }) async {
    final data = FormData();

    data.fields.add(MapEntry('title', title));

    data.fields.add(MapEntry('description', description));

    cohosts?.forEach((i) => data.fields.add(MapEntry('cohosts', i)));

    if (timezone != null) data.fields.add(MapEntry('timezone', timezone));

    if (image != null) {
      final imageData = MultipartFile.fromFileSync(
        image.path,
        filename: image.path.split(Platform.pathSeparator).last,
      );
      data.files.add(MapEntry('image', imageData));
    }

    return _client.upload(
      '/broadcasts',
      formData: data,
      fromJson: BroadcastDto.fromJson,
      cancelToken: cancelToken,
    );
  }

  Future<BroadcastDto?> editBroadcast(
    String broadcastId, {
    String? title,
    String? description,
    String? timezone,
    List<String>? cohosts,
    String? startTime,
    File? image,
    CancelToken? cancelToken,
  }) async {
    final data = FormData();

    if (title != null) data.fields.add(MapEntry('title', title));

    if (description != null) {
      data.fields.add(MapEntry('description', description));
    }

    if (timezone != null) data.fields.add(MapEntry('timezone', timezone));

    if (cohosts != null) {
      for (final i in cohosts) {
        data.fields.add(MapEntry('cohosts', i));
      }
    }

    if (startTime != null) data.fields.add(MapEntry('startTime', startTime));

    if (image != null) {
      final imageData = MultipartFile.fromFileSync(
        image.path,
        filename: image.path.split(Platform.pathSeparator).last,
      );
      data.files.add(MapEntry('image', imageData));
    }

    return _client.put(
      '/broadcasts/$broadcastId',
      data: data,
      fromJson: BroadcastDto.fromJson,
      cancelToken: cancelToken,
    );
  }

  Future<void> deleteBroadcast(String broadcastId, {CancelToken? cancelToken}) {
    return _client.deleteUnit(
      '/broadcasts/$broadcastId',
      cancelToken: cancelToken,
    );
  }

  Future<BroadcastDto?> joinBroadcast(
    String broadcastId, {
    CancelToken? cancelToken,
  }) async {
    return _client.post(
      '/broadcasts/$broadcastId/join',
      fromJson: (json) {
        if (json is! Map<String, dynamic>) throw Exception('Unknown type');
        final broadcastJson = json['broadcast'];
        final broadcastToken = json['broadcastToken'] as String?;
        return BroadcastDto.fromJson(broadcastJson, broadcastToken);
      },
      cancelToken: cancelToken,
    );
  }

  Future<BroadcastDto?> startBroadcast(
    String broadcastId, {
    CancelToken? cancelToken,
  }) async {
    return _client.put(
      '/broadcasts/$broadcastId/start',
      fromJson: BroadcastDto.fromJson,
      cancelToken: cancelToken,
    );
  }

  Future<dynamic> getBroadcasts(
    Map<String, dynamic> queryParameters, {
    CancelToken? cancelToken,
  }) async {
    return _client.get(
      '/broadcasts',
      queryParameters: queryParameters,
      fromJson: (json) => json,
      cancelToken: cancelToken,
    );
  }

  Future<List<ParticipantDto>> getLiveListeners(
    String broadcastId, {
    CancelToken? cancelToken,
  }) async {
    return _client.get(
      '/broadcasts/$broadcastId/live-listeners',
      fromJson: (json) {
        if (json is! List) {
          throw const UnknownException('Expected List but got different type');
        }
        return json.map(ParticipantDto.fromJson).toList();
      },
      cancelToken: cancelToken,
    );
  }

  Future<dynamic> getListeners(
    String broadcastId, {
    CancelToken? cancelToken,
  }) async {
    return _client.get(
      '/broadcasts/$broadcastId/listeners',
      fromJson: (json) => json,
      cancelToken: cancelToken,
    );
  }
}
