import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginated_folders.g.dart';

@JsonSerializable(genericArgumentFactories: true)
final class PaginatedFolders<FolderDto> with EquatableMixin {
  const PaginatedFolders({
    required this.folders,
    required this.totalPages,
    required this.totalItems,
    required this.currentPage,
  });

  factory PaginatedFolders.fromJson(
    Map<String, dynamic> json,
    FolderDto Function(Object?) fromJsonT,
  ) =>
      _$PaginatedFoldersFromJson(json, fromJsonT);

  final List<FolderDto?> folders;
  final int totalPages;
  final int totalItems;
  final int currentPage;

  @override
  List<Object?> get props => [folders, totalItems, totalPages, currentPage];

  Map<String, dynamic> toJson(Object? Function(FolderDto value) toJsonT) =>
      _$PaginatedFoldersToJson(this, toJsonT);

  @override
  bool? get stringify => true;
}
