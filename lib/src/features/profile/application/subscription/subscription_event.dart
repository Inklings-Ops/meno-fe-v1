part of 'subscription_bloc.dart';

sealed class SubscriptionEvent with EquatableMixin {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

final class SubscribeRequested extends SubscriptionEvent {
  const SubscribeRequested(this.user);
  final Profile user;

  @override
  List<Object?> get props => [user];
}

final class UnsubscribeRequested extends SubscriptionEvent {
  const UnsubscribeRequested(this.user);
  final Profile user;

  @override
  List<Object?> get props => [user];
}

final class SubscriptionsFetchRequested extends SubscriptionEvent {
  const SubscriptionsFetchRequested();
}

final class SubscribersFetchRequested extends SubscriptionEvent {
  const SubscribersFetchRequested();
}
