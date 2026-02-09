import 'dart:io' show File;

import 'package:equatable/equatable.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast_draft.dart';
import 'package:meno/shared/domain/domain.dart';

final class BroadcastDraftDto with EquatableMixin {
  const BroadcastDraftDto({
    required this.id,
    required this.title,
    required this.description,
    required this.lastModified,
    this.record = false,
    this.cohosts = const [],
    this.artwork,
  });

  factory BroadcastDraftDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid broadcast JSON');
    }

    return BroadcastDraftDto(
      id: json[_kId] as String,
      title: json[_kTitle] as String,
      description: json[_kDescription] as String,
      record: json[_kRecord] != null && json[_kRecord] as bool,
      cohosts: json[_kCohosts] != null
          ? (json[_kCohosts] as List).map((i) => i as String).toList()
          : const [],
      artwork: json[_kArtwork] as String?,
      lastModified: DateTime.parse(json[_kLastModified] as String),
    );
  }

  static const String _kId = 'id';
  static const String _kTitle = 'title';
  static const String _kDescription = 'description';
  static const String _kRecord = 'record';
  static const String _kCohosts = 'cohosts';
  static const String _kArtwork = 'artwork';
  static const String _kLastModified = 'lastModified';

  final String id;
  final String title;
  final String description;
  final bool record;
  final List<String?> cohosts;
  final String? artwork;
  final DateTime lastModified;

  Map<String, dynamic> toJson() => {
    _kId: id,
    _kTitle: title,
    _kDescription: description,
    _kRecord: record,
    _kCohosts: cohosts,
    _kArtwork: artwork,
    _kLastModified: lastModified.toIso8601String(),
  };

  BroadcastDraftDto copyWith({
    String? id,
    String? title,
    String? description,
    bool? record,
    List<String?>? cohosts,
    String? artwork,
    DateTime? lastModified,
  }) {
    return BroadcastDraftDto(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      record: record ?? this.record,
      cohosts: cohosts ?? this.cohosts,
      artwork: artwork ?? this.artwork,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    record,
    cohosts,
    artwork,
    lastModified,
  ];
}

extension BroadcastDraftDtoX on BroadcastDraftDto {
  BroadcastDraft get toDomain => BroadcastDraft(
    id: Id.fromString(id),
    title: SingleLineString(title),
    description: MultiLineString(description),
    record: record,
    cohosts: cohosts.isNotEmpty
        ? cohosts.map((id) => Id.fromString(id!)).toList()
        : const [],
    artwork: artwork != null ? ImageInput.fromFile(File(artwork!)) : null,
    lastModified: lastModified,
  );
}

extension BroadcastDraftX on BroadcastDraft {
  BroadcastDraftDto get toDto => BroadcastDraftDto(
    id: id.getOrCrash(),
    title: title.getOrCrash(),
    description: description.getOrCrash(),
    record: record,
    cohosts: cohosts.isNotEmpty
        ? cohosts.map((id) => id!.getOrCrash()).toList()
        : const [],
    artwork: switch (artwork?.getOrCrash()) {
      LocalImage(:final file) => file.path,
      _ => null,
    },
    lastModified: lastModified,
  );
}
