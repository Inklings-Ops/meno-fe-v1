part of 'notes_bloc.dart';

// Add status enum for finer control
enum NotesStatus { initial, loading, loadingMore, loadSuccess, failure }

@freezed
class NotesState with _$NotesState {
  const factory NotesState({
    @Default(NotesStatus.initial) NotesStatus status,
    @Default([]) List<Note?> notes,
    @Default(0) int currentPage,
    @Default(20) int pageSize,
    @Default(false) bool hasReachedMax,
    String? currentKeywords,
    NoteException? failure,
  }) = _NotesState;

  // Keep old factories for potential compatibility or remove if unused
  // const factory NotesState.initial() = NotesInitial;
  // const factory NotesState.loadInProgress() = NotesLoadInProgress;
  // const factory NotesState.loadSuccess(List<Note?> notes) = NotesLoadSuccess;
  // const factory NotesState.failure(NoteException failure) = NotesFailure;
}
