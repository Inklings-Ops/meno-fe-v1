part of 'stream_bloc.dart';

@freezed
class StreamState with _$StreamState {
  const factory StreamState({
    required Broadcast broadcast,
    @Default(LiveInitial()) LiveStatus status,
  }) = _StreamState;
}
