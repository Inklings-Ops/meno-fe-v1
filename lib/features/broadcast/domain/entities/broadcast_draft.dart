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
    this.artwork,
  });

  final Id id;
  final SingleLineString title;
  final MultiLineString description;
  final bool record;
  final List<Id?> cohosts;
  final ImageInput? artwork;
  final DateTime lastModified;

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
