part of 'live_broadcasts_bloc.dart';

@freezed
class LiveBroadcastsEvent with _$LiveBroadcastsEvent {
  const factory LiveBroadcastsEvent.getLiveBroadcasts() = _GetLiveBroadcasts;
  const factory LiveBroadcastsEvent.updateList(List<Broadcast?> broadcasts) = _UpdateBroadcastList;
  const factory LiveBroadcastsEvent.newBroadcast(Broadcast broadcast) = _NewBroadcast;
  const factory LiveBroadcastsEvent.endedBroadcast(Broadcast broadcast) = _EndedBroadcast;
}
