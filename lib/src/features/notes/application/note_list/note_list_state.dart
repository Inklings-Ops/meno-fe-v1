part of 'note_list_bloc.dart';

@freezed
class NoteListState with _$NoteListState {
  const factory NoteListState.empty() = _Empty;
  const factory NoteListState.loading() = _Loading;
  const factory NoteListState.success(List<Note?> notes) = _Success;
  const factory NoteListState.failure() = _Failure;
}
