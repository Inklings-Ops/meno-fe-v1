import 'dart:io' show File;

import 'package:equatable/equatable.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast_draft.dart';
import 'package:meno/shared/domain/domain.dart';

final class BroadcastDraftDto with EquatableMixin {
  const BroadcastDraftDto({
    required this.title,
    required this.description,
    this.record = false,
    this.cohosts = const [],
    this.artwork,
  });

  factory BroadcastDraftDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid broadcast JSON');
    }

    return BroadcastDraftDto(
      title: json[_kTitle] as String,
      description: json[_kDescription] as String,
      record: json[_kRecord] != null && json[_kRecord] as bool,
      cohosts: json[_kCohosts] != null
          ? (json[_kCohosts] as List).map((i) => i as String).toList()
          : const [],
      artwork: json[_kArtwork] as String?,
    );
  }

  static const String _kTitle = 'title';
  static const String _kDescription = 'description';
  static const String _kRecord = 'record';
  static const String _kCohosts = 'cohosts';
  static const String _kArtwork = 'artwork';

  final String title;
  final String description;
  final bool record;
  final List<String?> cohosts;
  final String? artwork;

  Map<String, dynamic> toJson() => {
    _kTitle: title,
    _kDescription: description,
    _kRecord: record,
    _kCohosts: cohosts,
    _kArtwork: artwork,
  };

  @override
  List<Object?> get props => [title, description, record, cohosts, artwork];
}

extension BroadcastDraftDtoX on BroadcastDraftDto {
  BroadcastDraft get toDomain => BroadcastDraft(
    title: SingleLineString(title),
    description: MultiLineString(description),
    record: record,
    cohosts: cohosts.isNotEmpty
        ? cohosts.map((id) => Id.fromString(id!)).toList()
        : const [],
    artwork: artwork != null ? ImageInput.fromFile(File(artwork!)) : null,
  );
}

extension BroadcastDraftX on BroadcastDraft {
  BroadcastDraftDto get toDto => BroadcastDraftDto(
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
  );
}
