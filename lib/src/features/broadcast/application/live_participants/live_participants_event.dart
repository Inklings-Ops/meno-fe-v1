part of 'live_participants_bloc.dart';

@freezed
class LiveParticipantsEvent with _$LiveParticipantsEvent {
  const factory LiveParticipantsEvent.fetch(String broadcastId) = FetchParticipants;
  const factory LiveParticipantsEvent.updateParticipantList(dynamic data) = _UpdateParticipantList;
  const factory LiveParticipantsEvent.updateParticipantNumber(dynamic data) = _UpdateParticipantNumber;
  const factory LiveParticipantsEvent.updateAfterFetch(dynamic data) = _UpdateAfterFetch;
}
