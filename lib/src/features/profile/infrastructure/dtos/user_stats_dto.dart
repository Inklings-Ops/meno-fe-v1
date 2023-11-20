import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats_dto.freezed.dart';
part 'user_stats_dto.g.dart';

@freezed
@JsonSerializable(createFactory: false, includeIfNull: false)
class UserStatsDto with _$UserStatsDto {
  factory UserStatsDto({
    int? subscribers,
    int? subscriptions,
    int? broadcasts,
  }) = _UserStatsDto;

  factory UserStatsDto.fromJson(Map<String, dynamic> json) =>
      _$UserStatsDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserStatsDtoToJson(this);
}
