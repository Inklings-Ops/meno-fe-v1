part of 'folder_bloc.dart';

sealed class FolderEvent with EquatableMixin {
  const FolderEvent();

  @override
  List<Object?> get props => [];
}

final class FolderRenameFolderRequested extends FolderEvent {
  const FolderRenameFolderRequested(this.folder);
  final Folder folder;

  @override
  List<Object?> get props => [folder];
}

final class FolderUpdateFolderNotesRequested extends FolderEvent {
  const FolderUpdateFolderNotesRequested(this.note);
  final Note note;

  @override
  List<Object?> get props => [note];
}

final class FolderGetFolderNotesRequested extends FolderEvent {
  const FolderGetFolderNotesRequested();
}

final class FolderCancelRequested extends FolderEvent {
  const FolderCancelRequested();
}
