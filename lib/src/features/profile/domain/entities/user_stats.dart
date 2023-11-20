import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';

@freezed
class UserStats with _$UserStats {
  factory UserStats({
    int? subscribers,
    int? subscriptions,
    int? broadcasts,
  }) = _UserStats;

  factory UserStats.empty() => UserStats(
        subscribers: 0,
        broadcasts: 0,
        subscriptions: 0,
      );
}
