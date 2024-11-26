part of 'folder_bloc.dart';

@freezed
class FolderState with _$FolderState {
  const factory FolderState({
    required Folder folder,
    @Default([]) List<Note?> notes,
    @Default(false) bool isLoadingNotes,
    NoteException? exception,
  }) = _FolderState;
}
