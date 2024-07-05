part of 'note_form_cubit.dart';

@freezed
class NoteFormState with _$NoteFormState {
  const factory NoteFormState({
    required Note note,
    required bool isEditing,
    required bool loading,
    required Option<Either<NoteException, Note>> option,
  }) = _NoteFormState;

  factory NoteFormState.initial() {
    return NoteFormState(
      note: Note.empty(),
      isEditing: false,
      loading: false,
      option: none(),
    );
  }
}
