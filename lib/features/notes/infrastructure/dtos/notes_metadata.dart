final class NotesMetadata {
  const NotesMetadata({
    required this.totalPages,
    required this.currentPage,
    required this.totalItems,
  });

  factory NotesMetadata.fromJson(Map<String, dynamic> json) => NotesMetadata(
    totalPages: (json['totalPages'] as num).toInt(),
    currentPage: (json['currentPage'] as num).toInt(),
    totalItems: (json['totalItems'] as num).toInt(),
  );

  final int totalPages;
  final int currentPage;
  final int totalItems;

  bool get hasMore => currentPage < totalPages;
}
