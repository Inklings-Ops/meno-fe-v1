part of 'recently_live_bloc.dart';

sealed class RecentlyLiveEvent with EquatableMixin {
  const RecentlyLiveEvent();

  @override
  List<Object?> get props => [];
}

final class RecentlyLiveStarted extends RecentlyLiveEvent {
  const RecentlyLiveStarted();
}

final class RecentlyLiveFetchMoreRequested extends RecentlyLiveEvent {
  const RecentlyLiveFetchMoreRequested();
}


final class _EndedBroadcastSubscribed extends RecentlyLiveEvent {
  const _EndedBroadcastSubscribed(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}
