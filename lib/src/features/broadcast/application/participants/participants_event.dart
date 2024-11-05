part of 'participants_bloc.dart';

@freezed
class ParticipantsEvent with _$ParticipantsEvent {
  const factory ParticipantsEvent.initialized(
    Broadcast broadcast,
  ) = ParticipantsInitialized;
  const factory ParticipantsEvent.participantsReloadPressed() =
      ParticipantsReloadPressed;
  const factory ParticipantsEvent.allParticipantsFetchPressed() =
      AllParticipantsFetchPressed;
  const factory ParticipantsEvent.participantLoaded(
    List<BroadcastParticipant> participants,
  ) = _ParticipantsLoaded;
  const factory ParticipantsEvent.participantJoined(
    BroadcastParticipant participant,
  ) = _ParticipantJoined;
  const factory ParticipantsEvent.participantLeft(
    BroadcastParticipant participant,
  ) = _ParticipantLeft;
  const factory ParticipantsEvent.reset() = ParticipantsReset;
}
