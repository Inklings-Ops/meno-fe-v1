part of 'now_live_bloc.dart';

sealed class NowLiveEvent with EquatableMixin {
  const NowLiveEvent();

  @override
  List<Object?> get props => [];
}

final class NowLiveStarted extends NowLiveEvent {
  const NowLiveStarted();
}

final class NowLiveFetchMoreRequested extends NowLiveEvent {
  const NowLiveFetchMoreRequested();
}

final class _NewBroadcastSubscribed extends NowLiveEvent {
  const _NewBroadcastSubscribed(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

final class _EndedBroadcastSubscribed extends NowLiveEvent {
  const _EndedBroadcastSubscribed(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}
