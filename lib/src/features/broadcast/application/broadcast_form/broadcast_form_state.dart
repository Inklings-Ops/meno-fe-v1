part of 'broadcast_form_cubit.dart';

@freezed
class BroadcastFormState with _$BroadcastFormState {
  const factory BroadcastFormState({
    required bool loading,
    required IBroadcastTitle title,
    IBroadcastDescription? description,
    IBroadcastArtwork? artwork,
    List<User>? cohosts,
    required bool shouldRecord,
    required Option<Either<BroadcastException, Broadcast>> option,
  }) = _BroadcastState;

  factory BroadcastFormState.initial() {
    return BroadcastFormState(
      loading: false,
      title: IBroadcastTitle(''),
      description: null,
      artwork: null,
      cohosts: null,
      shouldRecord: true,
      option: none(),
    );
  }
}
