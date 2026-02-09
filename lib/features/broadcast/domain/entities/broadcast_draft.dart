import 'package:equatable/equatable.dart';
import 'package:meno/shared/domain/domain.dart';

final class BroadcastDraft with EquatableMixin {
  const BroadcastDraft({
    required this.title,
    required this.description,
    this.record = false,
    this.cohosts = const [],
    this.artwork,
  });

  final SingleLineString title;
  final MultiLineString description;
  final bool record;
  final List<Id?> cohosts;
  final ImageInput? artwork;

  @override
  List<Object?> get props => [title, description, record, cohosts, artwork];
}
