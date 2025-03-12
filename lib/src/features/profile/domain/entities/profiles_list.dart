import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'profiles_list.freezed.dart';

@freezed
class ProfilesList with _$ProfilesList {
  const factory ProfilesList({
    required List<Profile?> profiles,
    required int totalItems,
    required int totalPages,
    required int currentPage,
  }) = _ProfilesList;

  factory ProfilesList.empty() {
    return const ProfilesList(
      profiles: [],
      currentPage: 1,
      totalItems: 1,
      totalPages: 1,
    );
  }
}
