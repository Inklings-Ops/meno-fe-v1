part of 'folders_bloc.dart';

@freezed
class FoldersEvent with _$FoldersEvent {
  const factory FoldersEvent.getAllFolders() = GetAllFolders;
  
  const factory FoldersEvent.updateFolders(
    Folder newFolder,
  ) = UpdateFolderList;
  
  const factory FoldersEvent.getFolderAndUpdateList(
    String id,
  ) = GetFolderAndUpdateList;
  
  const factory FoldersEvent.deleteFolder(Folder folder) = DeleteFolder;
}
