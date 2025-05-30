import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart' show Email;
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'note_creator_dto.g.dart';

@JsonSerializable()
class NoteCreatorDto with EquatableMixin {
  const NoteCreatorDto({
    required this.id,
    required this.fullName,
    required this.email,
    this.imageUrl,
  });

  factory NoteCreatorDto.fromJson(Map<String, dynamic> json) =>
      _$NoteCreatorDtoFromJson(json);

  final String id;
  final String fullName;
  final String email;
  final String? imageUrl;
  Map<String, dynamic> toJson() => _$NoteCreatorDtoToJson(this);

  @override
  List<Object?> get props => [ id, fullName, email, imageUrl];
}

extension NoteCreatorDtoToDomain on NoteCreatorDto {
  NoteCreator get toDomain {
    return NoteCreator(
      id: ID.fromString(id),
      fullName: SingleLineString(fullName),
      email: Email(email),
      imageUrl: imageUrl,
    );
  }
}

extension NoteCreatorToDto on NoteCreator {
  NoteCreatorDto get toDto {
    return NoteCreatorDto(
      id: id.getOrCrash(),
      fullName: fullName.getOrCrash(),
      email: email.getOrCrash(),
      imageUrl: imageUrl,
    );
  }
}
