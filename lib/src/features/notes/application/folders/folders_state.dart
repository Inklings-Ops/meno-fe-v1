part of 'folders_bloc.dart';

enum FoldersStatus { initial, loading, loadingMore, success, failure }

final class FoldersState with EquatableMixin {
  const FoldersState({
    this.status = FoldersStatus.initial,
    this.folders = const <Folder?>[],
    this.currentPage = 0,
    this.pageSize = 6,
    this.hasReachedMax = false,
    this.currentKeywords,
    this.failure,
  });

  final FoldersStatus status;
  final List<Folder?> folders;
  final int currentPage;
  final int pageSize;
  final bool hasReachedMax;
  final String? currentKeywords;
  final NoteException? failure;

  @override
  List<Object?> get props => [
        status,
        folders,
        currentPage,
        pageSize,
        hasReachedMax,
        currentKeywords,
        failure,
      ];

  FoldersState copyWith({
    FoldersStatus? status,
    List<Folder?>? folders,
    int? currentPage,
    int? pageSize,
    bool? hasReachedMax,
    String? currentKeywords,
    NoteException? failure,
  }) {
    return FoldersState(
      status: status ?? this.status,
      folders: folders ?? this.folders,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentKeywords: currentKeywords ?? this.currentKeywords,
      failure: failure ?? this.failure,
    );
  }
}
