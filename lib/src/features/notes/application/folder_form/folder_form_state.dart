part of 'folder_form_bloc.dart';

sealed class FolderFormState with EquatableMixin {
  const FolderFormState();

  @override
  List<Object?> get props => [];
}

final class FolderFormLoadSuccess extends FolderFormState {
  const FolderFormLoadSuccess(this.folder);
  final Folder folder;

  @override
  List<Object?> get props => [folder];
}

final class FolderFormSubmitSuccess extends FolderFormState {
  const FolderFormSubmitSuccess(this.folder);
  final Folder folder;

  @override
  List<Object?> get props => [folder];
}

final class FolderFormSubmitFailed extends FolderFormState {
  const FolderFormSubmitFailed(this.exception);
  final NoteException exception;

  @override
  List<Object?> get props => [exception];
}

final class FolderFormSubmitInProgress extends FolderFormState {
  const FolderFormSubmitInProgress();
}
