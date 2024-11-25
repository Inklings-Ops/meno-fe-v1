import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';

part 'folder_cubit.freezed.dart';
part 'folder_state.dart';

class FolderCubit extends Cubit<FolderState> {
  FolderCubit({
    required INoteFacade facade,
    required Folder folder,
  })  : _facade = facade,
        super(FolderLoaded(folder));
  final INoteFacade _facade;

  void renameFolder(Folder folder) {
    if (state is FolderLoaded) {
      final currentFolder = (state as FolderLoaded).folder;
      final renamedFolder = currentFolder.copyWith(title: folder.title);
      emit(FolderLoaded(renamedFolder));
    }
  }

  Future<void> getAllNotes() async {
    if (state is FolderLoaded) {
      final folderId = (state as FolderLoaded).folder.id;

      emit(const FolderLoadInProgress());

      final result = await _facade.getFolderWithNotes(folderId: folderId);

      result.fold(
        (error) => emit(FolderFailure(error)),
        (folder) => emit(FolderLoaded(folder!)),
      );
    }
  }

  Future<void> addToFolder(Note note, Folder folder) async {
    final folder = (state as FolderLoaded).folder;
    final notes = [...folder.notes ?? []];

    emit(const FolderLoadInProgress());

    final result = await _facade.addNoteToFolder(
      noteId: note.uid,
      folderId: folder.id,
    );

    return result.fold(
      (failure) => emit(FolderFailure(failure)),
      (note) {
        final index = notes.indexWhere((note) => note?.uid == note!.uid);
        if (index != -1) {
          notes[index] = note;
          emit(FolderLoaded(folder.copyWith(notes: [])));
        }
      },
    );
  }
}
