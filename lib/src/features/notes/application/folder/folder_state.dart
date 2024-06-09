part of 'folder_cubit.dart';

@freezed
class FolderState with _$FolderState {
  const factory FolderState.loading() = _Loading;
  const factory FolderState.success(Folder folder) = _Success;
  const factory FolderState.failure(NoteException error) = _Failure;
}
