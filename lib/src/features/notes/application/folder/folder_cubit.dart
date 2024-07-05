import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/features/notes/domain/exceptions/note_exception.dart';

part 'folder_cubit.freezed.dart';
part 'folder_state.dart';

class FolderCubit extends Cubit<FolderState> {
  final INoteFacade _facade;
  FolderCubit({
    required INoteFacade facade,
    required Folder folder,
  })  : _facade = facade,
        super(FolderState.success(folder));        

  Future<void> getAllNotes() async {
    if (state is _Success) {
      final folderId = (state as _Success).folder.id;

      emit(const _Loading());

      final result = await _facade.getFolderWithNotes(folderId: folderId);

      result.fold(
        (error) => emit(_Failure(error)),
        (folder) => emit(_Success(folder!)),
      );
    }
  }

  Future<void> addToFolder(Note note, Folder folder) async {
    final folder = (state as _Success).folder;
    final notes = [...folder.notes ?? []];

    emit(const _Loading());

    final result = await _facade.addNoteToFolder(
      noteId: note.uid.get()!,
      folderId: folder.id,
    );

    return result.fold(
      (failure) => emit(_Failure(failure)),
      (note) {
        final index = notes.indexWhere((note) => note?.uid == note!.uid);
        if (index != -1) {
          notes[index] = note;
          emit(_Success(folder.copyWith(notes: [])));
        }
      },
    );
  }
}
