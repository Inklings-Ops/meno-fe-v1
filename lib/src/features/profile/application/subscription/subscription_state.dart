part of 'subscription_bloc.dart';

@freezed
class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({
    @Default([]) List<Profile?> subscribers,
    @Default([]) List<Profile?> subscribtions,
    @Default(false) bool loading,
    AuthException? exception,
  }) = _SubscriptionState;
}
