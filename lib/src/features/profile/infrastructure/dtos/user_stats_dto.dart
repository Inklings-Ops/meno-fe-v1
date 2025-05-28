import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

part 'user_stats_dto.g.dart';

@JsonSerializable()
final class UserStatsDto with EquatableMixin {
  const UserStatsDto({
    this.subscribers = 0,
    this.subscriptions = 0,
    this.broadcasts = 0,
  });

  factory UserStatsDto.fromJson(Map<String, dynamic> json) =>
      _$UserStatsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatsDtoToJson(this);

  final int subscribers;
  final int subscriptions;
  final int broadcasts;

  @override
  List<Object?> get props => [subscribers, subscriptions, broadcasts];

  @override
  bool get stringify => true;
}

extension UserStatsToDtoX on UserStats {
  UserStatsDto get toDto {
    return UserStatsDto(
      broadcasts: broadcasts,
      subscribers: subscribers,
      subscriptions: subscriptions,
    );
  }
}

extension UserStatsToDomainX on UserStatsDto {
  UserStats get toDomain {
    return UserStats(
      broadcasts: broadcasts,
      subscribers: subscribers,
      subscriptions: subscriptions,
    );
  }
}
