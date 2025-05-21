part of 'participants_bloc.dart';

final class ParticipantsState with EquatableMixin {
  const ParticipantsState({
    this.liveParticipants = const [],
    this.numberOfLiveParticipants = 0,
    this.allParticipants = const [],
    this.numberOfAllParticipants = 0,
    this.loading = false,
    this.exception,
  });

  /// The list of participants currently live-streaming the broadcast
  final List<BroadcastParticipant> liveParticipants;

  /// The number of participants currently live-streaming the broadcast
  final int numberOfLiveParticipants;

  /// List of all the participants that joined through out the lifecycle
  /// of the broadcast
  final List<BroadcastParticipant> allParticipants;

  /// The total number of participants that joined through out the lifecycle
  /// of the broadcast
  final int numberOfAllParticipants;

  /// The loading state
  final bool loading;

  /// [BroadcastException] in case of a failed state
  final BroadcastException? exception;

  @override
  List<Object?> get props => [
        liveParticipants,
        numberOfLiveParticipants,
        allParticipants,
        numberOfAllParticipants,
        loading,
      ];

  ParticipantsState copyWith({
    List<BroadcastParticipant>? liveParticipants,
    int? numberOfLiveParticipants,
    List<BroadcastParticipant>? allParticipants,
    int? numberOfAllParticipants,
    bool? loading,
    BroadcastException? exception,
  }) {
    return ParticipantsState(
      liveParticipants: liveParticipants ?? this.liveParticipants,
      numberOfLiveParticipants:
          numberOfLiveParticipants ?? this.numberOfLiveParticipants,
      allParticipants: allParticipants ?? this.allParticipants,
      numberOfAllParticipants:
          numberOfAllParticipants ?? this.numberOfAllParticipants,
      loading: loading ?? this.loading,
      exception: exception ?? this.exception,
    );
  }
}
