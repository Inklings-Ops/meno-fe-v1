part of 'subscription_bloc.dart';

final class SubscriptionState with EquatableMixin {
  const SubscriptionState({
    this.subscribers = const [],
    this.subscriptions = const [],
    this.isLoading = false,
    this.exception,
  });

  final List<Profile?> subscribers;
  final List<Profile?> subscriptions;
  final bool isLoading;
  final ProfileException? exception;

  SubscriptionState copyWith({
    List<Profile?>? subscribers,
    List<Profile?>? subscriptions,
    bool? isLoading,
    ProfileException? exception,
  }) {
    return SubscriptionState(
      subscribers: subscribers ?? this.subscribers,
      subscriptions: subscriptions ?? this.subscriptions,
      isLoading: isLoading ?? this.isLoading,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [subscribers, subscriptions, isLoading, exception];
}
