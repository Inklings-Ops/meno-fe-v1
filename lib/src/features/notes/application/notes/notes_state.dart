part of 'notes_bloc.dart';

@freezed
class NotesState with _$NotesState {
  const factory NotesState({
    required List<Note?> notes,
    required bool isLoading,
    NoteException? exception,
  }) = _NotesState;

  factory NotesState.initial() {
    return const NotesState(
      notes: [],
      isLoading: false,
    );
  }
}
