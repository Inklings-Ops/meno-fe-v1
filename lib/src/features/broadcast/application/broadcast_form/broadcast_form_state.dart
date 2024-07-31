part of 'broadcast_form_cubit.dart';

@freezed
class BroadcastFormState with _$BroadcastFormState {
  factory BroadcastFormState.initial() {
    return BroadcastFormState(
      loading: false,
      title: SingleLineString(''),
      description: null,
      artwork: null,
      cohosts: null,
      shouldRecord: true,
      option: none(),
    );
  }
  factory BroadcastFormState({
    required bool loading,
    required SingleLineString title,
    required bool shouldRecord, required Option<Either<BroadcastException, Broadcast>> option, BroadcastDescription? description,
    BroadcastArtwork? artwork,
    List<User>? cohosts,
  }) = _BroadcastState;
  BroadcastFormState._();
  bool get isFormValid => title.isValid && description?.isValid == true;
}
