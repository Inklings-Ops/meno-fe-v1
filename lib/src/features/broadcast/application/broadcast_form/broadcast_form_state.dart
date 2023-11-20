part of 'broadcast_form_notifier.dart';

@freezed
class BroadcastFormState with _$BroadcastFormState {
  factory BroadcastFormState({
    required IBroadcastTitle title,
    IBroadcastDescription? description,
    IBroadcastArtwork? artwork,
    List<User>? cohosts,
    required bool recordingEnabled,
  }) = _BroadcastFormState;

  factory BroadcastFormState.initial() {
    return BroadcastFormState(
      title: IBroadcastTitle(""),
      description: null,
      artwork: null,
      cohosts: null,
      recordingEnabled: true,
    );
  }
}
