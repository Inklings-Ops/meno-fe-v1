part of 'subscription_bloc.dart';

@freezed
class SubscriptionEvent with _$SubscriptionEvent {
  const factory SubscriptionEvent.subscribe(Profile user) = Subscribe;
  const factory SubscriptionEvent.unsubscribe(Profile user) = Unsubscribe;
  const factory SubscriptionEvent.fetchSubscriptions() = FetchSubscriptions;
  const factory SubscriptionEvent.fetchSubscribers() = FetchSubscribers;
}
