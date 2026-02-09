import 'package:equatable/equatable.dart';
import 'package:meno/shared/domain/domain.dart';

final class BroadcastDraft with EquatableMixin {
  const BroadcastDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.lastModified,
    this.record = false,
    this.cohosts = const [],
    this.image,
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

  BroadcastDraft copyWith({
    SingleLineString? title,
    MultiLineString? description,
    bool? record,
    List<Id>? cohosts,
    ImageInput? image,
    DateTime? lastModified,
  }) {
    return BroadcastDraft(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      record: record ?? this.record,
      cohosts: cohosts ?? this.cohosts,
      image: image ?? this.image,
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
    image,
    lastModified,
  ];
}
