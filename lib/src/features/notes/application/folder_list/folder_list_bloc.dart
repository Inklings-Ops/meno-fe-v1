import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

part 'folder_list_bloc.freezed.dart';
part 'folder_list_event.dart';
part 'folder_list_state.dart';

class FolderListBloc extends Bloc<FolderListEvent, FolderListState> {
  FolderListBloc({
    required INoteFacade facade,
  })  : _facade = facade,
        super(const FolderListState.success([])) {
    on<_GetAllFolders>(_onGetAllFolders);
    on<_UpdateList>(_onUpdateList);
    on<_GetFolderAndUpdateList>(_onGetFolderAndUpdateList);
    on<_DeleteFolder>(_onDeleteFolder);
    on<_AddToFolder>(_onAddToFolder);
  }
  final INoteFacade _facade;

void init() => add(const FolderListEvent.getAllFolders());

  bool get hasFolders {
    if (state is _Success) {
      return (state as _Success).folders.isNotEmpty;
    } else {
      return false;
    }
  }

  Future<void> _onAddToFolder(
    _AddToFolder event,
    Emitter<FolderListState> emit,
  ) async {
    emit(const _Loading());
  }

  // Future<void> _onGetAllFolderNotes(
  //   _GetAllFolderNotes event,
  //   Emitter<FolderListState> emit,
  // ) async {
  //   emit(const _Loading());

  //   final result = await _facade.getFolderWithNotes(
  //     folderId: event.folder.id,
  //   );

  //   return result.fold(
  //     (failure) => emit(_Failure(failure)),
  //     (folder) => emit(_Success()),
  //   );
  // }

  Future<void> _onGetAllFolders(
    _GetAllFolders event,
    Emitter<FolderListState> emit,
  ) async {
    emit(const _Loading());

    final result = await _facade.getAllFolders();

    return result.fold(
      (failure) => emit(_Failure(failure)),
      (folders) => emit(_Success(folders)),
    );
  }

  Future<void> _onGetFolderAndUpdateList(
    _GetFolderAndUpdateList event,
    Emitter<FolderListState> emit,
  ) async {
    if (state is _Success) {
      final currentState = state as _Success;
      final folders = [...currentState.folders];

      emit(const _Loading());

      final result = await _facade.getFolder(folderId: event.id);

      return result.fold(
        (failure) => emit(_Failure(failure)),
        (folder) {
          final index = folders.indexWhere((f) => f?.id == folder!.id);
          if (index != -1) {
            folders[index] = folder;
            emit(_Success(folders));
          }
        },
      );
    }
  }

  Future<void> _onUpdateList(
    _UpdateList event,
    Emitter<FolderListState> emit,
  ) async {
    if (state is _Success) {
      final currentState = state as _Success;
      final folders = currentState.folders;

      if (folders.isEmpty) {
        add(const _GetAllFolders());
        return;
      }

      final index = folders.indexWhere((f) => f?.id == event.newFolder.id);
      final updatedFolders = [...folders];

      if (index != -1) {
        updatedFolders[index] = event.newFolder;
      } else {
        updatedFolders.insert(0, event.newFolder);
      }

      emit(_Success(updatedFolders));
    }
  }

  Future<void> _onDeleteFolder(
    _DeleteFolder event,
    Emitter<FolderListState> emit,
  ) async {
    final folders = [...(state as _Success).folders];

    emit(const _Loading());
    final result = await _facade.deleteFolder(event.folder.id);

    return result.fold(
      (failure) => emit(_Failure(failure)),
      (_) {
        folders.removeWhere((folder) => folder?.id == event.folder.id);
        emit(_Success(folders));
      },
    );
  }
}
