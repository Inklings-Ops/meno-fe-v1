import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

part 'folders_bloc.freezed.dart';
part 'folders_event.dart';
part 'folders_state.dart';

class FoldersBloc extends Bloc<FoldersEvent, FoldersState> {
  FoldersBloc({
    required INoteFacade facade,
  })  : _facade = facade,
        super(const FoldersLoaded([])) {
    on<GetAllFolders>(_onGetAllFolders);
    on<UpdateFolderList>(_onUpdateFolderList);
    on<GetFolderAndUpdateList>(_onGetFolderAndUpdateList);
    on<DeleteFolder>(_onDeleteFolder);

    add(const GetAllFolders());
  }

  final INoteFacade _facade;

  bool get hasFolders {
    if (state is FoldersLoaded) {
      return (state as FoldersLoaded).folders.isNotEmpty;
    } else {
      return false;
    }
  }

  Future<void> _onGetAllFolders(
    GetAllFolders event,
    Emitter<FoldersState> emit,
  ) async {
    emit(const FoldersLoading());

    final result = await _facade.getAllFolders();

    return result.fold(
      (failure) => emit(FoldersLoadFailed(failure)),
      (folders) => emit(FoldersLoaded(folders)),
    );
  }

  Future<void> _onGetFolderAndUpdateList(
    GetFolderAndUpdateList event,
    Emitter<FoldersState> emit,
  ) async {
    if (state is FoldersLoaded) {
      final currentState = state as FoldersLoaded;
      final folders = [...currentState.folders];

      emit(const FoldersLoading());

      final result = await _facade.getFolder(folderId: event.folderId);

      return result.fold(
        (failure) => emit(FoldersLoadFailed(failure)),
        (folder) {
          final index = folders.indexWhere((f) => f?.id == folder!.id);
          if (index != -1) {
            folders[index] = folder;
            emit(FoldersLoaded(folders));
          }
        },
      );
    }
  }

  Future<void> _onUpdateFolderList(
    UpdateFolderList event,
    Emitter<FoldersState> emit,
  ) async {
    if (state is FoldersLoaded) {
      final currentState = state as FoldersLoaded;
      final folders = currentState.folders;

      if (folders.isEmpty) {
        add(const GetAllFolders());
      } else {
        final index = folders.indexWhere((f) => f?.id == event.newFolder.id);
        final updatedFolders = [...folders];

        if (index != -1) {
          updatedFolders[index] = event.newFolder;
        } else {
          updatedFolders.insert(0, event.newFolder);
        }

        emit(FoldersLoaded(updatedFolders));
      }
    }
  }

  Future<void> _onDeleteFolder(
    DeleteFolder event,
    Emitter<FoldersState> emit,
  ) async {
    final folders = [...(state as FoldersLoaded).folders];

    emit(const FoldersLoading());
    final result = await _facade.deleteFolder(event.folder.id);

    return result.fold(
      (failure) => emit(FoldersLoadFailed(failure)),
      (_) {
        folders.removeWhere((folder) => folder?.id == event.folder.id);
        emit(FoldersLoaded(folders));
      },
    );
  }
}
