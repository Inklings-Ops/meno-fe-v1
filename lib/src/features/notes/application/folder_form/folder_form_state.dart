part of 'folder_form_bloc.dart';

@freezed
class FolderFormState with _$FolderFormState {
  const factory FolderFormState.loaded(Folder folder) = FolderFormLoaded;
  const factory FolderFormState.submitting() = FolderFormSubmitInProgress;
  const factory FolderFormState.submitted(Folder folder) = FolderFormSubmitted;
  const factory FolderFormState.failure(
    NoteException exception,
  ) = FolderFormFailure;
}
