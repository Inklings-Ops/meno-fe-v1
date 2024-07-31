import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/infrastructure/dtos/dtos.dart';

import 'package:meno_fe_v1/src/features/discover/domain/domain.dart';

part 'discover_result_dto.freezed.dart';
part 'discover_result_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class DiscoverResultDto with _$DiscoverResultDto {
  factory DiscoverResultDto({
    required List<BroadcastDto?> broadcasts,
    required int totalItems,
    required int totalPages,
    required int currentPage,
  }) = _DiscoverResultDto;
  factory DiscoverResultDto.fromJson(Map<String, dynamic> json) =>
      _$DiscoverResultDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DiscoverResultDtoToJson(this);
}

extension DiscoverDtoX on DiscoverResultDto {
  DiscoverResult get toDomain {
    return DiscoverResult(
      broadcasts: broadcasts.map((b) => b?.toDomain).toList(),
      totalItems: totalItems,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}
