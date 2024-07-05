part of 'folder_form_cubit.dart';

@freezed
class FolderFormState with _$FolderFormState {
  const factory FolderFormState({
    Folder? initialFolder,
    required FolderTitle title,
    required bool loading,
    required Option<Either<NoteException, Folder>> option,
  }) = _FolderFormState;

  factory FolderFormState.initial() {
    return FolderFormState(
      initialFolder: null,
      title: FolderTitle(''),
      loading: false,
      option: none(),
    );
  }
}
