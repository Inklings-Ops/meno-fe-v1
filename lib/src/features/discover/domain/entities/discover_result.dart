import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';

part 'discover_result.freezed.dart';

@freezed
class DiscoverResult with _$DiscoverResult {
  const factory DiscoverResult({
    required List<Broadcast?> broadcasts,
    required int totalItems,
    required int totalPages,
    required int currentPage,
  }) = _DiscoverResult;

  factory DiscoverResult.empty() {
    return const DiscoverResult(
      broadcasts: [],
      currentPage: 1,
      totalItems: 0,
      totalPages: 1,
    );
  }
}
