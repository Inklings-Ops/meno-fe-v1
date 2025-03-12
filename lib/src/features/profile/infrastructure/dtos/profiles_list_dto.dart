import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'profiles_list_dto.freezed.dart';
part 'profiles_list_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class ProfilesListDto with _$ProfilesListDto {
  const factory ProfilesListDto({
    @JsonKey(name: 'users') required List<ProfileDto?> profiles,
    required int totalItems,
    required int totalPages,
    required int currentPage,
  }) = _ProfilesListDto;

  factory ProfilesListDto.empty() {
    return const ProfilesListDto(
      profiles: [],
      currentPage: 1,
      totalItems: 1,
      totalPages: 1,
    );
  }

  factory ProfilesListDto.fromJson(Map<String, dynamic> json) =>
      _$ProfilesListDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfilesListDtoToJson(this);
}

extension PListToDomainX on ProfilesListDto {
  ProfilesList get toDomain {
    return ProfilesList(
      profiles: profiles.map((p) => p?.toDomain).toList(),
      totalItems: totalItems,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}

extension PListToDtoX on ProfilesList {
  ProfilesListDto get toDto {
    return ProfilesListDto(
      profiles: profiles.map((p) => p?.toDto).toList(),
      totalItems: totalItems,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}
