import 'dart:async';
import 'dart:io' show Platform;

import 'package:dio/dio.dart' show CancelToken, FormData, MultipartFile;
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/model/_model.dart';

final class BroadcastHttpService {
  const BroadcastHttpService(this._client);

  final HttpClient _client;

  Future<Broadcast> createBroadcast({
    required SingleLineString title,
    required MultiLineString description,
    String? timezone,
    List<Id>? cohosts,
    ImageInput? image,
    CancelToken? cancelToken,
  }) async {
    final data = FormData();

    data.fields.add(MapEntry('title', title.getOrCrash()));

    data.fields.add(MapEntry('description', description.getOrCrash()));

    if (cohosts?.isNotEmpty ?? false) {
      cohosts?.forEach(
        (i) => data.fields.add(MapEntry('cohosts', i.getOrCrash())),
      );
    }

    if (timezone != null) data.fields.add(MapEntry('timezone', timezone));

    final imageFile = image?.getFile();
    if (imageFile != null) {
      final imageData = MultipartFile.fromFileSync(
        imageFile.path,
        filename: imageFile.path.split(Platform.pathSeparator).last,
      );
      data.files.add(MapEntry('image', imageData));
    }

    return _client.upload(
      '/broadcasts',
      formData: data,
      fromJson: (json) => BroadcastDto.fromJson(json).toDomain,
      cancelToken: cancelToken,
    );
  }

  Future<Broadcast> editBroadcast(
    Id broadcastId, {
    SingleLineString? title,
    MultiLineString? description,
    String? timezone,
    List<Id>? cohosts,
    DateTime? startTime,
    ImageInput? image,
    CancelToken? cancelToken,
  }) async {
    final data = FormData();

    if (title != null) data.fields.add(MapEntry('title', title.getOrCrash()));

    if (description != null) {
      data.fields.add(MapEntry('description', description.getOrCrash()));
    }

    if (timezone != null) data.fields.add(MapEntry('timezone', timezone));

    if (cohosts != null) {
      for (final i in cohosts) {
        data.fields.add(MapEntry('cohosts', i.getOrCrash()));
      }
    }

    if (startTime != null) {
      data.fields.add(MapEntry('startTime', startTime.toIso8601String()));
    }

    final imageFile = image?.getFile();
    if (imageFile != null) {
      final imageData = MultipartFile.fromFileSync(
        imageFile.path,
        filename: imageFile.path.split(Platform.pathSeparator).last,
      );
      data.files.add(MapEntry('image', imageData));
    }

    return _client.put(
      '/broadcasts/$broadcastId',
      data: data,
      fromJson: (json) => BroadcastDto.fromJson(json).toDomain,
      cancelToken: cancelToken,
    );
  }

  Future<void> deleteBroadcast(Id broadcastId, {CancelToken? cancelToken}) {
    return _client.deleteUnit(
      '/broadcasts/${broadcastId.getOrCrash()}',
      cancelToken: cancelToken,
    );
  }

  Future<Broadcast> joinBroadcast(
    Id broadcastId, {
    CancelToken? cancelToken,
  }) async {
    return _client.post(
      '/broadcasts/${broadcastId.getOrCrash()}/join',
      fromJson: (json) {
        if (json is! Map<String, dynamic>) throw Exception('Unknown type');
        final broadcastJson = json['broadcast'];
        final broadcastToken = json['broadcastToken'] as String?;
        return BroadcastDto.fromJson(broadcastJson, broadcastToken).toDomain;
      },
      cancelToken: cancelToken,
    );
  }

  Future<Broadcast> startBroadcast(
    Id broadcastId, {
    CancelToken? cancelToken,
  }) async {
    return _client.put(
      '/broadcasts/${broadcastId.getOrCrash()}/start',
      fromJson: (json) => BroadcastDto.fromJson(json).toDomain,
      cancelToken: cancelToken,
    );
  }

  Future<PagedList<Broadcast?>> getBroadcasts(
    BroadcastQuery query, {
    CancelToken? cancelToken,
  }) async {
    return _client.get(
      '/broadcasts',
      queryParameters: query.toApiParams,
      fromJson: (json) => PagedList<Broadcast?>.fromJson(
        json as Map<String, dynamic>,
        (jsonT) => BroadcastDto.fromJson(jsonT).toDomain,
        listKey: 'broadcasts',
      ),
      cancelToken: cancelToken,
    );
  }

  Future<Broadcast> getBroadcast(
    Id broadcastId, {
    CancelToken? cancelToken,
  }) async {
    return _client.get(
      '/broadcasts',
      queryParameters: {'id': broadcastId.getOrCrash()},
      fromJson: (json) {
        if (json is! Map<String, dynamic>) throw Exception('Unknown type');
        final items = json['broadcasts'] as List<dynamic>;
        if (items.isEmpty) throw const MenoException('No broadcast found');
        return BroadcastDto.fromJson(items.first).toDomain;
      },
      cancelToken: cancelToken,
    );
  }

  Future<List<Participant>> getLiveListeners(
    Id broadcastId, {
    CancelToken? cancelToken,
  }) async {
    return _client.get(
      '/broadcasts/${broadcastId.getOrCrash()}/live-listeners',
      fromJson: (json) {
        if (json is! List) throw FormatError<List<ParticipantDto>>();
        return json.map((e) => ParticipantDto.fromJson(e).toDomain).toList();
      },
      cancelToken: cancelToken,
    );
  }

  Future<PagedList<Participant?>> getListeners(
    Id broadcastId, {
    CancelToken? cancelToken,
  }) async {
    return _client.get(
      '/broadcasts/${broadcastId.getOrCrash()}/listeners',
      fromJson: (json) => PagedList<Participant?>.fromJson(
        json as Map<String, dynamic>,
        (jsonT) => ParticipantDto.fromJson(jsonT).toDomain,
      ),
      cancelToken: cancelToken,
    );
  }
}
