import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:objectbox/objectbox.dart';

part 'note_creator_dto.freezed.dart';
part 'note_creator_dto.g.dart';

@Freezed(addImplicitFinal: false)
@JsonSerializable(explicitToJson: true, createFactory: false)
class NoteCreatorDto with _$NoteCreatorDto {
  @Entity(realClass: NoteCreatorDto)
  factory NoteCreatorDto({
    @Unique() required String id, required String fullName, required String email, @Id() int? dbId,
   String? imageUrl,
  }) = _NoteCreatorDto;

  NoteCreatorDto._();

  factory NoteCreatorDto.fromJson(Map<String, dynamic> json) =>
      _$NoteCreatorDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NoteCreatorDtoToJson(this);
}

extension NoteCreatorDtoToDomain on NoteCreatorDto {
  NoteCreator get toDomain {
    return NoteCreator(
      dbId: dbId,
      id: id,
      fullName: fullName,
      imageUrl: fullName,
      email:email,
    );
  }
}

extension NoteCreatorToDto on NoteCreator {
  NoteCreatorDto get toDto {
    return NoteCreatorDto(
      dbId: dbId,
      id: id,
      fullName: fullName,
      imageUrl: fullName,
      email:email,
    );
  }
}


/*
- Isaiah 44:2-3
- Isaiah 53:10
- The seed that you gave to your servant BDM, he has planted that seed, pour 
  your Spirit upon that seed and your blessing upon on it and cause it to 
  prosper in his hand.
*/