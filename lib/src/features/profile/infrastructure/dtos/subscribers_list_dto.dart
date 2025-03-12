import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'subscribers_list_dto.freezed.dart';
part 'subscribers_list_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class SubscribersListDto with _$SubscribersListDto {
  const factory SubscribersListDto({
    required List<ProfileDto?> subscribers,
    required int totalItems,
    required int totalPages,
    required int currentPage,
  }) = _SubscribersListDto;

  factory SubscribersListDto.empty() {
    return const SubscribersListDto(
      subscribers: [],
      currentPage: 1,
      totalItems: 1,
      totalPages: 1,
    );
  }

  factory SubscribersListDto.fromJson(Map<String, dynamic> json) =>
      _$SubscribersListDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SubscribersListDtoToJson(this);
}

extension SubListToDomainX on SubscribersListDto {
  SubscribersList get toDomain {
    return SubscribersList(
      subscribers: subscribers.map((p) => p?.toDomain).toList(),
      totalItems: totalItems,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}

extension SubListToDtoX on SubscribersList {
  SubscribersListDto get toDto {
    return SubscribersListDto(
      subscribers: subscribers.map((p) => p?.toDto).toList(),
      totalItems: totalItems,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}
