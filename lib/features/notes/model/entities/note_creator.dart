import 'package:equatable/equatable.dart';
import 'package:meno/_core/value_objects/value_objects.dart';
import 'package:meno/_shared/model/entities/entity.dart';

class NoteCreator with EquatableMixin implements IEntity {
  const NoteCreator({
    required this.id,
    required this.fullName,
    required this.email,
    this.imageUrl,
  });

  @override
  final Id id;

  final SingleLineString fullName;
  final Email email;
  final String? imageUrl;

  static const NoteCreator empty = NoteCreator(
    id: Id.empty,
    fullName: SingleLineString.empty,
    email: Email.empty,
  );

  @override
  List<Object?> get props => [id, fullName, email, imageUrl];
}
