part of 'folders_bloc.dart';

enum FoldersStatus { initial, loading, loadingMore, success, failure }

@freezed
class FoldersState with _$FoldersState {
  const factory FoldersState({
    @Default(FoldersStatus.initial) FoldersStatus status,
    @Default([]) List<Folder?> folders,
    @Default(0) int currentPage,
    @Default(6) int pageSize,
    @Default(false) bool hasReachedMax,
    String? currentKeywords,
    NoteException? failure,
  }) = _FoldersState;
}
