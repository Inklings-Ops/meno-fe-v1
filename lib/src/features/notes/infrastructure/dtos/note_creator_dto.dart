import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';


part 'note_creator_dto.freezed.dart';
part 'note_creator_dto.g.dart';

@freezed
@JsonSerializable(explicitToJson: true, createFactory: false)
class NoteCreatorDto with _$NoteCreatorDto {
  factory NoteCreatorDto({
    required String id,
    required String fullName,
    required String imageUrl,
  }) = _NoteCreatorDto;

  factory NoteCreatorDto.fromJson(Map<String, dynamic> json) =>
      _$NoteCreatorDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NoteCreatorDtoToJson(this);
}

extension NoteCreatorDtoToDomain on NoteCreatorDto {
  NoteCreator get toDomain {
    return NoteCreator(
      id: id,
      fullName: fullName,
      imageUrl: fullName,
    );
  }
}

extension NoteCreatorToDto on NoteCreator {
  NoteCreatorDto get toDto {
    return NoteCreatorDto(
      id: id,
      fullName: fullName,
      imageUrl: fullName,
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