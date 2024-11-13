part of 'participants_bloc.dart';

@freezed
class ParticipantsState with _$ParticipantsState {
  const factory ParticipantsState({
    /// The list of participants currently live-streaming the broadcast
    required List<BroadcastParticipant> liveParticipants,

    /// The number of participants currently live-streaming the broadcast
    required int numberOfLiveParticipants,

    /// List of all the participants that joined through out the lifecycle
    /// of the broadcast
    required List<BroadcastParticipant> allParticipants,

    /// The total number of participants that joined through out the lifecycle
    /// of the broadcast
    required int numberOfAllParticipants,

    /// The loading state
    @Default(false) bool loading,

    /// [BroadcastException] in case of a failed state
    BroadcastException? exception,
  }) = _ParticipantsState;

  factory ParticipantsState.initial() {
    return const ParticipantsState(
      liveParticipants: [],
      numberOfLiveParticipants: 0,
      allParticipants: [],
      numberOfAllParticipants: 0,
    );
  }
}
