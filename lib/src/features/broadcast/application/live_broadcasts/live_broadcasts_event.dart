part of 'live_broadcasts_bloc.dart';

@freezed
class LiveBroadcastsEvent with _$LiveBroadcastsEvent {
  const factory LiveBroadcastsEvent.getLiveBroadcasts() = _GetLiveBroadcasts;
  const factory LiveBroadcastsEvent.filter(dynamic data) = _FilterBroadcasts;
  const factory LiveBroadcastsEvent.updateOnNewBroadcast(dynamic data) =
      _UpdateOnNewBroadcast;
  const factory LiveBroadcastsEvent.updateOnEndedBroadcast(dynamic data) =
      _UpdateOnEndedBroadcast;
}
