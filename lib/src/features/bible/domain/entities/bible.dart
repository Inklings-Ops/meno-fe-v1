import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/bible/domain/entities/verse.dart';

final class Bible with EquatableMixin {
  const Bible({
    required this.translation,
    required this.verses,
    this.id,
  });

  final String translation;
  final List<Verse> verses;
  final int? id;

  @override
  List<Object?> get props => [translation, verses, id];
}
