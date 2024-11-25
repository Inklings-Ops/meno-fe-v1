part of 'folder_form_bloc.dart';

@freezed
class FolderFormEvent with _$FolderFormEvent {
  const factory FolderFormEvent.init(Folder folder) = InitializeFolderForm;

  const factory FolderFormEvent.titleChanged(
    FolderTitle title,
  ) = FolderTitleChanged;

  const factory FolderFormEvent.submit() = SubmitFolderForm;
}
