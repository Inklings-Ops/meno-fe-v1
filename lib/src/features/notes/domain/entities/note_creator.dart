import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

class NoteCreator with EquatableMixin implements IEntity {
  const NoteCreator({
    required this.id,
    required this.fullName,
    required this.email,
    this.imageUrl,
  });

  @override
  final ID id;

  final SingleLineString fullName;
  final Email email;
  final String? imageUrl;

  static NoteCreator empty = NoteCreator(
    id: ID.fromString(''),
    fullName: SingleLineString(''),
    email: Email(''),
  );

  @override
  List<Object?> get props => [id, fullName, email, imageUrl];
}
