part of 'folder_cubit.dart';

@freezed
class FolderState with _$FolderState {
  const factory FolderState.loading() = FolderLoadInProgress;
  const factory FolderState.loadingNotes() = FolderNotesLoadInProgress;
  const factory FolderState.loaded(Folder folder) = FolderLoaded;
  const factory FolderState.failure(NoteException error) = FolderFailure;
}
