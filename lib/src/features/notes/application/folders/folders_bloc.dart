import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';
import 'package:rxdart/rxdart.dart';

part 'folders_bloc.freezed.dart';
part 'folders_event.dart';
part 'folders_state.dart';

class FoldersBloc extends Bloc<FoldersEvent, FoldersState> {
  FoldersBloc({
    required INoteFacade facade,
  })  : _facade = facade,
        super(const FoldersState()) {
    on<GetFoldersRequested>(
      _onGetFoldersRequested,
      transformer: _debounceAndSwitch(),
    );
    on<FetchMoreFolders>(
      _onFetchMoreFolders,
      transformer: _throttleDroppable(),
    );
    on<FolderSearchChanged>(_onFolderSearchChanged);
    on<UpdateFolderList>(_onUpdateFolderList);
    on<GetFolderAndUpdateList>(_onGetFolderAndUpdateList);
    on<FolderRemoved>(_onFolderRemoved);

    add(const GetFoldersRequested());
  }

  final INoteFacade _facade;

  EventTransformer<E> _debounceAndSwitch<E>() {
    return (events, mapper) => events
        .debounceTime(const Duration(milliseconds: 500))
        .switchMap(mapper);
  }

  EventTransformer<E> _throttleDroppable<E>() {
    return (events, mapper) => events
        .throttleTime(
          const Duration(milliseconds: 300),
          leading: true,
          trailing: false,
        )
        .switchMap(mapper); // Process the event
  }

  bool get hasFolders {
    return state.status == FoldersStatus.success && state.folders.isNotEmpty;
  }

  Future<void> _onGetFoldersRequested(
    GetFoldersRequested event,
    Emitter<FoldersState> emit,
  ) async {
    const pageToFetch = 1;
    final pageSize = event.size;

    emit(
      state.copyWith(
        status: FoldersStatus.loading,
        currentKeywords: event.title,
        currentPage: pageToFetch,
      ),
    );

    final result = await _facade.getAllFolders(
      folderId: event.folderId,
      orderBy: event.orderBy,
      page: pageToFetch,
      size: pageSize,
      pinned: event.pinned,
      sortBy: event.sortBy,
      title: event.title,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FoldersStatus.failure,
          failure: failure,
        ),
      ),
      (folders) => emit(
        state.copyWith(
          status: FoldersStatus.success,
          folders: folders,
          currentPage: pageToFetch,
          pageSize: pageSize,
          hasReachedMax: folders.length < pageSize,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onFetchMoreFolders(
    FetchMoreFolders event,
    Emitter<FoldersState> emit,
  ) async {
    // Prevent fetching if already maxed out or already loading more
    if (state.hasReachedMax || state.status == FoldersStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: FoldersStatus.loadingMore));

    final nextPage = state.currentPage + 1;

    final result = await _facade.getAllFolders(
      title: state.currentKeywords,
      page: nextPage,
      size: state.pageSize,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FoldersStatus.failure,
          failure: failure,
        ),
      ),
      (newFolders) => emit(
        state.copyWith(
          status: FoldersStatus.success,
          folders: List.of(state.folders)..addAll(newFolders),
          currentPage: nextPage,
          hasReachedMax: newFolders.length < state.pageSize,
          failure: null,
        ),
      ),
    );
  }

  void _onFolderSearchChanged(
    FolderSearchChanged event,
    Emitter<FoldersState> emit,
  ) {
    add(
      GetFoldersRequested(
        title: event.keywords.isEmpty ? null : event.keywords,
        size: state.pageSize,
      ),
    );
  }

  void _onReloadFolders(ReloadFolders event, Emitter<FoldersState> emit) {
    add(GetFoldersRequested(size: state.pageSize));
  }

  Future<void> _onGetFolderAndUpdateList(
    GetFolderAndUpdateList event,
    Emitter<FoldersState> emit,
  ) async {
    if (state.status == FoldersStatus.success ||
        state.status == FoldersStatus.loadingMore) {
      final folders = [...state.folders];

      emit(state.copyWith(status: FoldersStatus.loading));

      final result = await _facade.getFolder(folderId: event.folderId);

      return result.fold(
        (failure) => emit(
          state.copyWith(
            status: FoldersStatus.failure,
            failure: failure,
          ),
        ),
        (folder) {
          final index = folders.indexWhere((f) => f?.id == folder!.id);
          if (index != -1) {
            folders[index] = folder;
          } else {
            folders.insert(0, folder);
          }
          emit(state.copyWith(folders: folders, status: FoldersStatus.success));
        },
      );
    }
  }

  Future<void> _onUpdateFolderList(
    UpdateFolderList event,
    Emitter<FoldersState> emit,
  ) async {
    if (state.status == FoldersStatus.success ||
        state.status == FoldersStatus.loadingMore) {
      final folders = [...state.folders];
      final index = folders.indexWhere((f) => f?.id == event.newFolder.id);

      if (index != -1) {
        folders[index] = event.newFolder;
      } else {
        folders.insert(0, event.newFolder);
      }

      emit(state.copyWith(folders: folders));
    }
  }

  void _onFolderRemoved(FolderRemoved event, Emitter<FoldersState> emit) {
    if (state.status == FoldersStatus.success ||
        state.status == FoldersStatus.loadingMore) {
      final folderId = event.folder.id;
      final newFolders = state.folders.where((e) => e?.id != folderId).toList();
      emit(state.copyWith(folders: newFolders));
    }
  }
}
