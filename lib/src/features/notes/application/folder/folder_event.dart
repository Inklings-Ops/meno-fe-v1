part of 'folder_bloc.dart';

@freezed
class FolderEvent with _$FolderEvent {
  const factory FolderEvent.renameFolder(Folder folder) = RenameFolder;
  const factory FolderEvent.getFolderNotes() = GetFolderNotes;
  const factory FolderEvent.updateFolderNotes(Note note) = UpdateFolderNotes;
  const factory FolderEvent.cancel() = CancelFolderRequest;
}
