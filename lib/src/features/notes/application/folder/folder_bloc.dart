// ignore_for_file: avoid_redundant_argument_values

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';

part 'folder_event.dart';
part 'folder_state.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  FolderBloc({
    required INoteFacade facade,
    required Folder folder,
  })  : _facade = facade,
        super(FolderState(folder: folder)) {
    on<FolderRenameFolderRequested>(_onRenameFolder);
    on<FolderGetFolderNotesRequested>(_onGetNotes);
    on<FolderCancelRequested>(_onCancel);
    on<FolderUpdateFolderNotesRequested>(_onUpdateFolderNotes);
  }

  final INoteFacade _facade;

  CancelToken? _cancelToken;

  void _onRenameFolder(
    FolderRenameFolderRequested event,
    Emitter<FolderState> emit,
  ) {
    final renamedFolder = state.folder.copyWith(title: event.folder.title);
    emit(state.copyWith(folder: renamedFolder));
  }

  Future<void> _onGetNotes(
    FolderGetFolderNotesRequested event,
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
          folder: folder,
          notes: folder?.notes,
          isLoadingNotes: false,
        ),
      ),
    );
  }

  void _onUpdateFolderNotes(
    FolderUpdateFolderNotesRequested event,
    Emitter<FolderState> emit,
  ) {
    final notes = List<Note?>.from(state.notes);
    final index = notes.indexWhere((n) => n?.id == event.note.id);

    if (index == -1) {
      notes.insert(0, event.note);
      emit(state.copyWith(notes: notes));
    } else {
      final newNotes = notes.where((n) => n?.id != event.note.id).toList();
      emit(state.copyWith(notes: newNotes));
    }
  }

  void _onCancel(FolderCancelRequested event, Emitter<FolderState> emit) {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('Request cancelled by user.');
    }
  }
}
