import 'package:equatable/equatable.dart';
import 'package:meno/shared/domain/domain.dart';

/// Represents the sort items for query results
enum SortBy {
  title('title'),
  status('status'),
  startTime('startTime'),
  endTime('endTime');

  const SortBy(this.value);

  final String value;
}

/// Represents additional fields to include in the broadcast response
enum BroadcastIncludeField {
  totalListeners('totalListeners');

  const BroadcastIncludeField(this.value);

  final String value;
}

/// Value object representing time range filter
final class TimeRange with EquatableMixin {
  const TimeRange({this.greaterThan, this.lessThan, this.exists});

  final String? greaterThan;
  final String? lessThan;
  final bool? exists;

  bool get hasFilter =>
      greaterThan != null || lessThan != null || exists != null;

  @override
  List<Object?> get props => [greaterThan, lessThan, exists];
}

/// Value object ensuring sortBy and orderBy are always used together
final class SortParams with EquatableMixin {
  const SortParams({required this.sortBy, required this.orderBy});

  final SortBy sortBy;
  final OrderBy orderBy;

  @override
  List<Object?> get props => [sortBy, orderBy];
}

/// Value object for pagination parameters
final class PaginationParams with EquatableMixin {
  const PaginationParams({this.page = 1, this.size = 20})
    : assert(page > 0, 'Page must be greater than 0'),
      assert(size > 0 && size <= 20, 'Size must be between 1 and 20');

  PaginationParams next() => PaginationParams(page: page + 1, size: size);

  PaginationParams previous() =>
      PaginationParams(page: page > 1 ? page - 1 : 1, size: size);

  final int page;
  final int size;

  @override
  List<Object?> get props => [page, size];
}

/// Immutable query object encapsulating all broadcast query parameters
/// Following the Query Object pattern from DDD
final class BroadcastQuery with EquatableMixin {
  const BroadcastQuery({
    this.id,
    this.sortParams,
    this.status,
    this.includeFields = const [],
    this.onlySubscriptions = false,
    this.keywords,
    this.creatorId,
    this.pagination = const PaginationParams(),
    this.endTimeRange,
    this.startTimeRange,
  });

  /// Factory constructor for fetching user's subscriptions
  factory BroadcastQuery.subscriptions({
    SortParams? sortParams,
    PaginationParams pagination = const PaginationParams(),
  }) => BroadcastQuery(
    onlySubscriptions: true,
    sortParams: sortParams,
    pagination: pagination,
  );

  /// Factory constructor for creator's broadcasts
  factory BroadcastQuery.byCreator({
    required Id creatorId,
    BroadcastStatus? status,
    SortParams? sortParams,
    PaginationParams pagination = const PaginationParams(),
  }) => BroadcastQuery(
    creatorId: creatorId,
    status: status,
    sortParams: sortParams,
    pagination: pagination,
  );

  final Id? id;
  final SortParams? sortParams;
  final BroadcastStatus? status;
  final List<BroadcastIncludeField>? includeFields;
  final bool onlySubscriptions;
  final String? keywords;
  final Id? creatorId;
  final PaginationParams pagination;
  final TimeRange? endTimeRange;
  final TimeRange? startTimeRange;

  /// Creates a copy with modified parameters
  BroadcastQuery copyWith({
    SortParams? sortParams,
    Id? id,
    BroadcastStatus? status,
    List<BroadcastIncludeField>? includeFields,
    bool? onlySubscriptions,
    String? keywords,
    Id? creatorId,
    PaginationParams? pagination,
    TimeRange? endTimeRange,
    TimeRange? startTimeRange,
  }) => BroadcastQuery(
    sortParams: sortParams ?? this.sortParams,
    id: id ?? this.id,
    status: status ?? this.status,
    includeFields: includeFields ?? this.includeFields,
    onlySubscriptions: onlySubscriptions ?? this.onlySubscriptions,
    keywords: keywords ?? this.keywords,
    creatorId: creatorId ?? this.creatorId,
    pagination: pagination ?? this.pagination,
    endTimeRange: endTimeRange ?? this.endTimeRange,
    startTimeRange: startTimeRange ?? this.startTimeRange,
  );

  /// Navigate to next page
  BroadcastQuery next() => copyWith(pagination: pagination.next());

  /// Navigate to previous page
  BroadcastQuery previous() => copyWith(pagination: pagination.previous());

  @override
  List<Object?> get props => [
    id,
    sortParams,
    status,
    includeFields,
    onlySubscriptions,
    keywords,
    creatorId,
    pagination,
    endTimeRange,
    startTimeRange,
  ];
}
