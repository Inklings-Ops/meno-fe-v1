part of 'notes_bloc.dart';

// Add status enum for finer control
enum NotesStatus { initial, loading, loadingMore, loadSuccess, failure }

final class NotesState with EquatableMixin {
  const NotesState({
    this.notes = const <Note?>[],
    this.status = NotesStatus.initial,
    this.currentPage = 0,
    this.pageSize = 20,
    this.hasReachedMax = false,
    this.currentKeywords,
    this.failure,
  });

  final List<Note?> notes;
  final NotesStatus status;
  final int currentPage;
  final int pageSize;
  final bool hasReachedMax;
  final String? currentKeywords;
  final NoteException? failure;

  NotesState copyWith({
    List<Note?>? notes,
    NotesStatus? status,
    int? currentPage,
    int? pageSize,
    bool? hasReachedMax,
    String? currentKeywords,
    NoteException? failure,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      status: status ?? this.status,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentKeywords: currentKeywords ?? this.currentKeywords,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
        notes,
        status,
        currentPage,
        pageSize,
        hasReachedMax,
        currentKeywords,
        failure,
      ];
}
