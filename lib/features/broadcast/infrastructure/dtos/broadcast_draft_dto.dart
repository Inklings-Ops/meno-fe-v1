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
    this.image,
    this.createdBroadcastId,
    this.creationStep,
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
      image: json[_kImage] as String?,
      lastModified: DateTime.parse(json[_kLastModified] as String),
      createdBroadcastId: json[_kCreatedBroadcastId] as String?,
      creationStep: json[_kCreationStep] != null
          ? int.tryParse(json[_kCreationStep].toString())
          : null,
    );
  }

  static const String _kId = 'id';
  static const String _kTitle = 'title';
  static const String _kDescription = 'description';
  static const String _kRecord = 'record';
  static const String _kCohosts = 'cohosts';
  static const String _kImage = 'image';
  static const String _kLastModified = 'lastModified';
  static const String _kCreatedBroadcastId = 'createdBroadcastId';
  static const String _kCreationStep = 'creationStep';

  final String id;
  final String title;
  final String description;
  final bool record;
  final List<String> cohosts;
  final String? image;
  final DateTime lastModified;
  final String? createdBroadcastId;
  final int? creationStep;

  Map<String, dynamic> toJson() => {
    _kId: id,
    _kTitle: title,
    _kDescription: description,
    _kRecord: record,
    _kCohosts: cohosts,
    _kImage: image,
    _kLastModified: lastModified.toIso8601String(),
    _kCreatedBroadcastId: createdBroadcastId,
    _kCreationStep: creationStep,
  };

  BroadcastDraftDto copyWith({
    String? id,
    String? title,
    String? description,
    bool? record,
    List<String>? cohosts,
    String? image,
    DateTime? lastModified,
    String? createdBroadcastId,
    int? creationStep,
  }) {
    return BroadcastDraftDto(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      record: record ?? this.record,
      cohosts: cohosts ?? this.cohosts,
      image: image ?? this.image,
      lastModified: lastModified ?? this.lastModified,
      createdBroadcastId: createdBroadcastId ?? this.createdBroadcastId,
      creationStep: creationStep ?? this.creationStep,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    record,
    cohosts,
    image,
    lastModified,
    createdBroadcastId,
    creationStep,
  ];
}

extension BroadcastDraftDtoX on BroadcastDraftDto {
  BroadcastDraft get toDomain => BroadcastDraft(
    id: Id.fromString(id),
    title: SingleLineString(title),
    description: MultiLineString(description),
    record: record,
    cohosts: cohosts.isNotEmpty
        ? cohosts.map(Id.fromString).toList()
        : const [],
    image: image != null ? ImageInput.fromFile(File(image!)) : null,
    lastModified: lastModified,
    createdBroadcastId: createdBroadcastId != null
        ? Id.fromString(createdBroadcastId!)
        : null,
    creationStep:
        creationStep != null &&
            creationStep! < BroadcastCreationStep.values.length
        ? BroadcastCreationStep.values[creationStep!]
        : BroadcastCreationStep.none,
  );
}

extension BroadcastDraftX on BroadcastDraft {
  BroadcastDraftDto get toDto => BroadcastDraftDto(
    id: id.getOrCrash(),
    title: title.getOrCrash(),
    description: description.getOrCrash(),
    record: record,
    cohosts: cohosts.isNotEmpty
        ? cohosts.map((id) => id.getOrCrash()).toList()
        : const [],
    image: switch (image?.getOrCrash()) {
      LocalImage(:final file) => file.path,
      _ => null,
    },
    lastModified: lastModified,
    createdBroadcastId: createdBroadcastId?.getOrCrash(),
    creationStep: creationStep.index,
  );
}
