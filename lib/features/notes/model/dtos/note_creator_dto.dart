import 'package:meno/_core/_core.dart' as core;
import 'package:meno/features/notes/model/entities/_entities.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class NoteCreatorDto {
  NoteCreatorDto({
    required this.id,
    required this.fullName,
    required this.email,
    this.imageUrl,
    this.dbId = 0,
  });

  factory NoteCreatorDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid NoteCreator JSON format');
    }

    return NoteCreatorDto(
      id: json[_kId] as String,
      fullName: json[_kFullName] as String,
      email: json[_kEmail] as String,
      imageUrl: json[_kImageUrl] as String?,
    );
  }

  @Id()
  int dbId;

  @Unique()
  final String id;

  final String fullName;

  final String email;

  final String? imageUrl;

  static const String _kId = 'id';
  static const String _kFullName = 'fullName';
  static const String _kEmail = 'email';
  static const String _kImageUrl = 'imageUrl';

  Map<String, dynamic> toJson() => {
    _kId: id,
    _kFullName: fullName,
    _kEmail: email,
    _kImageUrl: imageUrl,
  };
}

extension NoteCreatorDtoX on NoteCreatorDto {
  NoteCreator get toDomain => NoteCreator(
    id: core.Id.fromString(id),
    fullName: core.SingleLineString(fullName),
    email: core.Email(email),
    imageUrl: imageUrl,
  );
}

extension NoteCreatorDomainX on NoteCreator {
  NoteCreatorDto get toDto => NoteCreatorDto(
    id: id.getOrCrash(),
    fullName: fullName.getOrCrash(),
    email: email.getOrCrash(),
    imageUrl: imageUrl,
  );
}
