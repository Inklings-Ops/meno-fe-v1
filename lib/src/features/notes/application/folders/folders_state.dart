part of 'folders_bloc.dart';

@freezed
class FoldersState with _$FoldersState {
  const factory FoldersState.loading() = FoldersLoading;
  const factory FoldersState.loaded(List<Folder?> folders) = FoldersLoaded;
  const factory FoldersState.failed(NoteException error) = FoldersLoadFailed;
}
