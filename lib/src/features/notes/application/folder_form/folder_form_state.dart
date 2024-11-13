part of 'folder_form_cubit.dart';

@freezed
class FolderFormState with _$FolderFormState {
  const factory FolderFormState({
    required FolderTitle title,
    required bool loading,
    required Option<Either<NoteException, Folder>> option,
    Folder? initialFolder,
  }) = _FolderFormState;

  factory FolderFormState.initial() {
    return FolderFormState(
      title: FolderTitle(''),
      loading: false,
      option: none(),
    );
  }
}
