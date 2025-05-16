import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'subscribers_list.freezed.dart';

@freezed
class SubscribersList with _$SubscribersList {
  const factory SubscribersList({
    required List<Profile?> subscribers,
    required int totalItems,
    required int totalPages,
    required int currentPage,
  }) = _SubscribersList;

  factory SubscribersList.empty() {
    return const SubscribersList(
      subscribers: [],
      currentPage: 1,
      totalItems: 1,
      totalPages: 1,
    );
  }
}
