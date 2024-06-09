part of 'folder_list_bloc.dart';

@freezed
class FolderListEvent with _$FolderListEvent {
  const factory FolderListEvent.getAllFolders() = _GetAllFolders;
  const factory FolderListEvent.addToFolder(Note note, Folder folder) = _AddToFolder;
  const factory FolderListEvent.updateList(Folder newFolder) = _UpdateList;
  const factory FolderListEvent.getFolderAndUpdateList(String id) = _GetFolderAndUpdateList;
  const factory FolderListEvent.deleteFolder(Folder folder) = _DeleteFolder;
}
