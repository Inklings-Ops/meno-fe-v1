part of 'folder_list_bloc.dart';

@freezed
class FolderListState with _$FolderListState {
  // const factory FolderListState.empty() = _Empty;
  const factory FolderListState.loading() = _Loading;
  const factory FolderListState.success(List<Folder?> folders) = _Success;
  const factory FolderListState.failure(NoteException error) = _Failure;
}
