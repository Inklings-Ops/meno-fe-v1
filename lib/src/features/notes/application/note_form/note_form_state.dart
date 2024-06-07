part of 'note_form_cubit.dart';

@freezed
class NoteFormState with _$NoteFormState {
  const factory NoteFormState({
    Note? initialNote,
    required INoteTitle title,
    required INoteContent content,
    required bool loading,
    required Option<Either<NoteException, Note>> option,
  }) = _NoteFormState;

  factory NoteFormState.initial() {
    return NoteFormState(
      initialNote: null,
      title: INoteTitle(''),
      content: INoteContent(''),
      loading: false,
      option: none(),
    );
  }
}
