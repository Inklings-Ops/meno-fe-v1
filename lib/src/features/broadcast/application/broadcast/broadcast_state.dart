part of 'broadcast_bloc.dart';

@freezed
class BroadcastState with _$BroadcastState {
  const factory BroadcastState.loading() = BroadcastLoadInProgress;
  const factory BroadcastState.failure(BroadcastException e) = BroadcastFailure;

  // Starting the broadcast
  const factory BroadcastState.startSuccess({
    required Broadcast broadcast,
    required bool muted,
  }) = BroadcastStartSuccess;
  const factory BroadcastState.startFailed(Object? e) = BroadcastStartFailed;

  // Ending the broadcast
  const factory BroadcastState.endSuccess() = BroadcastEndSuccess;

  // Deleting the broadcast
  const factory BroadcastState.deleteSuccess() = BroadcastDeleteSuccess;
}
