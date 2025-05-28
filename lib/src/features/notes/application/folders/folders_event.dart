part of 'folders_bloc.dart';

@freezed
class FoldersEvent with _$FoldersEvent {
  const factory FoldersEvent.getFoldersRequested({
    String? title,
    ID? folderId,
    @Default(false) bool pinned,
    @Default('createdAt') String sortBy,
    @Default('DESC') String orderBy,
    @Default(1) int page,
    @Default(6) int size,
  }) = GetFoldersRequested;

// Fetch next page for pagination
  const factory FoldersEvent.fetchMoreFolders() = FetchMoreFolders;

  // Search input changed
  const factory FoldersEvent.searchChanged(String keywords) =
      FolderSearchChanged;

  // Reload first page, clear search
  const factory FoldersEvent.reloadFolders() = ReloadFolders;

  // Remove a folder from the current list (client-side)
  const factory FoldersEvent.folderRemoved(Folder folder) = FolderRemoved;

  const factory FoldersEvent.updateFolders(
    Folder newFolder,
  ) = UpdateFolderList;

  const factory FoldersEvent.getFolderAndUpdateList(
    ID folderId,
  ) = GetFolderAndUpdateList;
}
