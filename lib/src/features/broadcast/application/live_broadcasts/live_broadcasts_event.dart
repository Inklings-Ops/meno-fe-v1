part of 'live_broadcasts_bloc.dart';

@freezed
class LiveBroadcastsEvent with _$LiveBroadcastsEvent {
  const factory LiveBroadcastsEvent.getLiveBroadcasts() = GetLiveBroadcasts;
  const factory LiveBroadcastsEvent.getMoreLiveBroadcasts() = GetMoreLiveBroadcasts;
  const factory LiveBroadcastsEvent.newBroadcast(
    Broadcast broadcast,
  ) = NewBroadcastReceived;
  const factory LiveBroadcastsEvent.endedBroadcast(
    EndedBroadcastData data,
  ) = EndedBroadcastReceived;
}
