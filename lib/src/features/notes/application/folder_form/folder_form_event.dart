part of 'folder_form_bloc.dart';

sealed class FolderFormEvent with EquatableMixin {
  const FolderFormEvent();

  @override
  List<Object?> get props => [];
}

final class FolderFormInitializeRequested extends FolderFormEvent {
  const FolderFormInitializeRequested(this.folder);
  final Folder folder;

  @override
  List<Object?> get props => [folder];
}

final class FolderFormTitleChanged extends FolderFormEvent {
  const FolderFormTitleChanged(this.title);
  final SingleLineString title;

  @override
  List<Object?> get props => [title];
}

final class FolderFormSubmitRequested extends FolderFormEvent {
  const FolderFormSubmitRequested();
}
