// ignore_for_file: use_if_null_to_convert_nulls_to_bools

part of 'broadcast_form_cubit.dart';

@freezed
class BroadcastFormState with _$BroadcastFormState {
  const factory BroadcastFormState({
    required bool loading,
    required SingleLineString title,
    required bool shouldRecord,
    required Option<Either<BroadcastException, Broadcast>> option,
    BroadcastDescription? description,
    BroadcastArtwork? artwork,
    List<User>? cohosts,
  }) = _BroadcastState;

  factory BroadcastFormState.initial() {
    return BroadcastFormState(
      loading: false,
      title: SingleLineString(''),
      shouldRecord: true,
      option: none(),
    );
  }

  const BroadcastFormState._();

  bool get isFormValid => title.isValid || description?.isValid == true;
}
