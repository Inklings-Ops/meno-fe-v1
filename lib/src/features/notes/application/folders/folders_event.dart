part of 'folders_bloc.dart';

@freezed
class FoldersEvent with _$FoldersEvent {
  const factory FoldersEvent.getAllFolders() = GetAllFolders;
  
  const factory FoldersEvent.updateFolders(
    Folder newFolder,
  ) = UpdateFolderList;
  
  const factory FoldersEvent.getFolderAndUpdateList(
    Uid<Folder> folderId,
  ) = GetFolderAndUpdateList;
  
  const factory FoldersEvent.folderRemoved(Folder folder) = FolderRemoved;
}
