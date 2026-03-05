import 'package:equatable/equatable.dart';
import 'package:meno/_core/value_objects/value_objects.dart';

/// Tracks which step of broadcast creation has completed
enum BroadcastCreationStep {
  none,
  created, // Broadcast entity created in DB
  started, // Broadcast started (LiveKit session initiated)
  saved, // Session saved to local storage
}

final class BroadcastDraft with EquatableMixin {
  const BroadcastDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.lastModified,
    this.record = false,
    this.cohosts = const [],
    this.image,
    this.createdBroadcastId,
    this.creationStep = BroadcastCreationStep.none,
  });

  static BroadcastDraft empty = BroadcastDraft(
    id: Id.empty,
    title: SingleLineString.empty,
    description: MultiLineString.empty,
    lastModified: DateTime.now(),
  );

  static BroadcastDraft newDraft = BroadcastDraft(
    id: Id.unique(),
    title: SingleLineString.empty,
    description: MultiLineString.empty,
    lastModified: DateTime.now(),
  );

  final Id id;
  final SingleLineString title;
  final MultiLineString description;
  final bool record;
  final List<Id> cohosts;
  final ImageInput? image;
  final DateTime lastModified;

  // Crash recovery fields
  final Id? createdBroadcastId;
  final BroadcastCreationStep creationStep;

  BroadcastDraft copyWith({
    SingleLineString? title,
    MultiLineString? description,
    bool? record,
    List<Id>? cohosts,
    ImageInput? image,
    DateTime? lastModified,
    Id? createdBroadcastId,
    BroadcastCreationStep? creationStep,
  }) {
    return BroadcastDraft(
      id: id,
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

  /// Whether this draft has a partial broadcast creation in progress
  bool get hasPartialCreation =>
      creationStep != BroadcastCreationStep.none && createdBroadcastId != null;

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
