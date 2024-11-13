part of 'live_broadcasts_bloc.dart';

@freezed
class LiveBroadcastsEvent with _$LiveBroadcastsEvent {
  const factory LiveBroadcastsEvent.getLiveBroadcasts() = _GetLiveBroadcasts;
  const factory LiveBroadcastsEvent.newBroadcast(
    Broadcast broadcast,
  ) = NewBroadcastReceived;
  const factory LiveBroadcastsEvent.endedBroadcast(
    EndedBroadcastData data,
  ) = EndedBroadcastReceived;
}
