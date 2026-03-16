import 'package:equatable/equatable.dart';

class UserNotificationSettings with EquatableMixin {
  const UserNotificationSettings({
    this.addedAsCoHost = false,
    this.userSubscribed = false,
    this.scheduledBroadcast = false,
    this.liveBroadcastStarted = false,
  });

  final bool addedAsCoHost;
  final bool userSubscribed;
  final bool scheduledBroadcast;
  final bool liveBroadcastStarted;

  UserNotificationSettings copyWith({
    bool? addedAsCoHost,
    bool? userSubscribed,
    bool? scheduledBroadcast,
    bool? liveBroadcastStarted,
  }) {
    return UserNotificationSettings(
      addedAsCoHost: addedAsCoHost ?? this.addedAsCoHost,
      userSubscribed: userSubscribed ?? this.userSubscribed,
      scheduledBroadcast: scheduledBroadcast ?? this.scheduledBroadcast,
      liveBroadcastStarted: liveBroadcastStarted ?? this.liveBroadcastStarted,
    );
  }

  @override
  List<Object?> get props => [
    addedAsCoHost,
    userSubscribed,
    scheduledBroadcast,
    liveBroadcastStarted,
  ];
}
