part of 'notes_bloc.dart';

@freezed
class NotesState with _$NotesState {
  const factory NotesState.initial() = NotesInitial;

  const factory NotesState.loadInProgress() = NotesLoadInProgress;

  const factory NotesState.loadSuccess(List<Note?> notes) = NotesLoadSuccess;

  const factory NotesState.failure(NoteException failure) = NotesFailure;
}
