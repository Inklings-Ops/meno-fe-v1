import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';

part 'folder_bloc.freezed.dart';
part 'folder_event.dart';
part 'folder_state.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  FolderBloc({
    required INoteFacade facade,
    required Folder folder,
  })  : _facade = facade,
        super(FolderState(folder: folder)) {
    on<RenameFolder>(_onRenameFolder);
    on<GetFolderNotes>(_onGetNotes);
    on<CancelFolderRequest>(_onCancel);
  }

  final INoteFacade _facade;

  CancelToken? _cancelToken;

  void _onRenameFolder(RenameFolder event, Emitter<FolderState> emit) {
    final renamedFolder = state.folder.copyWith(title: event.folder.title);
    emit(state.copyWith(folder: renamedFolder));
  }

  Future<void> _onGetNotes(
    GetFolderNotes event,
    Emitter<FolderState> emit,
  ) async {
    if (state.isLoadingNotes) return;

    emit(state.copyWith(isLoadingNotes: true, exception: null));

    _cancelToken = CancelToken();

    final result = await _facade.getFolderWithNotes(
      folderId: state.folder.id,
      cancelToken: _cancelToken,
    );

    emit(
      result.fold(
        (exception) => state.copyWith(
          exception: exception,
          isLoadingNotes: false,
        ),
        (folder) => state.copyWith(
          folder: folder!,
          notes: folder.notes,
          isLoadingNotes: false,
        ),
      ),
    );
  }

  // Future<void> addToFolder(Note note, Folder folder) async {
  //   final folder = (state as FolderLoaded).folder;
  //   final notes = [...folder.notes ?? []];

  //   emit(const FolderLoadInProgress());

  //   final result = await _facade.addNoteToFolder(
  //     noteId: note.uid,
  //     folderId: folder.id,
  //   );

  //   return result.fold(
  //     (failure) => emit(FolderFailure(failure)),
  //     (note) {
  //       final index = notes.indexWhere((note) => note?.uid == note!.uid);
  //       if (index != -1) {
  //         notes[index] = note;
  //         emit(FolderLoaded(folder.copyWith(notes: [])));
  //       }
  //     },
  //   );
  // }

  void _onCancel(CancelFolderRequest event, Emitter<FolderState> emit) {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('Request cancelled by user.');
    }
  }
}
