import 'dart:io';

import 'package:dio/dio.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';

final class BroadcastRemoteDataSource {
  const BroadcastRemoteDataSource(this._client);

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

  Future<BroadcastDto?> startBroadcast(
    String broadcastId, {
    CancelToken? cancelToken,
  }) async {
    return _client.post(
      '/broadcasts/$broadcastId/start',
      fromJson: BroadcastDto.fromJson,
      cancelToken: cancelToken,
    );
  }

  Future<PagedList<BroadcastDto?>> getBroadcasts(
    Map<String, dynamic> params, {
    CancelToken? cancelToken,
  }) async {
    return _client.get(
      '/broadcasts',
      queryParameters: params,
      fromJson: (json) => PagedList.fromJson(json, BroadcastDto.fromJson),
      cancelToken: cancelToken,
    );
  }
}
