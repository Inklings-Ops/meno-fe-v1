part of 'broadcast_form_notifier.dart';

@freezed
class BroadcastFormState with _$BroadcastFormState {
  factory BroadcastFormState({
    required IBroadcastTitle title,
    IBroadcastDescription? description,
    IBroadcastArtwork? artwork,
    List<User>? cohosts,
    required bool recordingEnabled,
    required bool showError,
    required bool loading,
    required Option<Either<BroadcastException, Broadcast>> option,
  }) = _BroadcastFormState;

  factory BroadcastFormState.initial() {
    return BroadcastFormState(
      title: IBroadcastTitle(""),
      description: null,
      artwork: null,
      cohosts: null,
      recordingEnabled: true,
      showError: false,
      loading: false,
      option: none(),
    );
  }
}
