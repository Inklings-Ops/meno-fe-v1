part of 'folders_bloc.dart';

sealed class FoldersEvent with EquatableMixin {
  const FoldersEvent();

  @override
  List<Object?> get props => [];
}

final class FoldersGetFoldersRequested extends FoldersEvent {
  const FoldersGetFoldersRequested({
    this.pinned = false,
    this.sortBy = 'createdAt',
    this.orderBy = 'DESC',
    this.page = 1,
    this.size = 6,
    this.title,
    this.folderId,
  });

  final String? title;
  final ID? folderId;
  final bool pinned;
  final String sortBy;
  final String orderBy;
  final int page;
  final int size;

  @override
  List<Object?> get props => [
        title,
        folderId,
        pinned,
        sortBy,
        orderBy,
        page,
        size,
      ];
}

final class FoldersGetMoreFoldersRequested extends FoldersEvent {
  const FoldersGetMoreFoldersRequested();
}

final class FoldersSearchKeywordsChanged extends FoldersEvent {
  const FoldersSearchKeywordsChanged(this.keywords);
  final String keywords;

  @override
  List<Object?> get props => [keywords];
}

final class FoldersReloadRequested extends FoldersEvent {
  const FoldersReloadRequested();
}

final class FoldersRemoveFolderRequested extends FoldersEvent {
  const FoldersRemoveFolderRequested(this.folder);
  final Folder folder;

  @override
  List<Object?> get props => [folder];
}

final class FoldersUpdateFoldersRequested extends FoldersEvent {
  const FoldersUpdateFoldersRequested(this.newFolder);
  final Folder newFolder;

  @override
  List<Object?> get props => [newFolder];
}

final class FoldersGetFolderAndUpdateList extends FoldersEvent {
  const FoldersGetFolderAndUpdateList(this.folderId);
  final ID folderId;

  @override
  List<Object?> get props => [folderId];
}
