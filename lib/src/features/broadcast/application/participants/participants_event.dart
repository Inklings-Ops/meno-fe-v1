part of 'participants_bloc.dart';

@freezed
class ParticipantsEvent with _$ParticipantsEvent {
  const factory ParticipantsEvent.getLiveParticipants(
    Uid<Broadcast> broadcastId,
  ) = GetLiveParticipants;

  const factory ParticipantsEvent.participantsReloadPressed(
    Uid<Broadcast> broadcastId,
  ) = ParticipantsReloadPressed;

  const factory ParticipantsEvent.getAllParticipants(
    Uid<Broadcast> broadcastId,
  ) = GetAllParticipants;

  const factory ParticipantsEvent.participantJoined(
    BroadcastParticipant participant,
  ) = ParticipantJoined;

  const factory ParticipantsEvent.participantLeft(
    BroadcastParticipant participant,
  ) = ParticipantLeft;

  const factory ParticipantsEvent.reset() = ParticipantsReset;
}
