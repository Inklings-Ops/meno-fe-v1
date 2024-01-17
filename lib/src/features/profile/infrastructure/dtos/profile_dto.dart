import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_stats_dto.dart';

part 'profile_dto.freezed.dart';
part 'profile_dto.g.dart';

@freezed
@JsonSerializable(
  createFactory: false,
  includeIfNull: false,
  explicitToJson: true,
)
class ProfileDto with _$ProfileDto {
  factory ProfileDto({
    required String id,
    required String fullName,
    String? bio,
    String? imageUrl,
    // ignore: invalid_annotation_target
    @JsonKey(name: '_count') UserStatsDto? stats,
    bool? isSubscribedToUser,
    bool? verified,
  }) = _ProfileDto;

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);
}
