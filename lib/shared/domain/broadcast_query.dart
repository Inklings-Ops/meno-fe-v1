import 'package:equatable/equatable.dart';
import 'package:meno/shared/domain/domain.dart';

/// Represents the type of a broadcasts to show
enum BroadcastsType {
  nowLive('nowLive'),
  recentlyLive('recentlyLive'),
  forYou('forYou');

  const BroadcastsType(this.value);

  final String value;

  String get title => switch (this) {
    BroadcastsType.recentlyLive => 'Recently Live',
    BroadcastsType.nowLive => 'Now Live',
    BroadcastsType.forYou => 'Live For You',
  };

  static BroadcastsType? fromString(String? value) {
    if (value == null) return null;
    try {
      return BroadcastsType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

/// Represents the sort items for query results
enum SortBy {
  title('title'),
  status('status'),
  startTime('startTime'),
  endTime('endTime');

  const SortBy(this.value);

  final String value;

  static SortBy? fromString(String? value) {
    if (value == null) return null;
    try {
      return SortBy.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

/// Value object representing time range filter
final class TimeRange with EquatableMixin {
  const TimeRange({this.gt, this.lt, this.exists});

  const TimeRange.exists() : gt = null, lt = null, exists = true;

  const TimeRange.notExists() : gt = null, lt = null, exists = false;

  factory TimeRange.between(String start, String end) =>
      TimeRange(gt: start, lt: end);

  /// Greater than
  final String? gt;

  /// Less than
  final String? lt;

  /// Exists
  final bool? exists;

  bool get hasFilter => gt != null || lt != null || exists != null;

  bool get isEmpty => !hasFilter;

  @override
  List<Object?> get props => [gt, lt, exists];

  @override
  String toString() => 'TimeRange(gt: $gt, lt: $lt, exists: $exists)';
}

/// Value object ensuring sortBy and orderBy are always used together
final class SortParams with EquatableMixin {
  const SortParams({required this.sortBy, required this.orderBy});

  static const startTimeAsc = SortParams(
    sortBy: SortBy.startTime,
    orderBy: OrderBy.asc,
  );

  static const startTimeDesc = SortParams(
    sortBy: SortBy.startTime,
    orderBy: OrderBy.desc,
  );

  static const endTimeAsc = SortParams(
    sortBy: SortBy.endTime,
    orderBy: OrderBy.asc,
  );

  static const endTimeDesc = SortParams(
    sortBy: SortBy.endTime,
    orderBy: OrderBy.desc,
  );

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

  static const defaultSize = 20;
  static const maxSize = 100;

  bool get isFirstPage => page == 1;

  PaginationParams next() => PaginationParams(page: page + 1, size: size);

  PaginationParams previous() =>
      PaginationParams(page: page > 1 ? page - 1 : 1, size: size);

  PaginationParams reset() => PaginationParams(size: size);

  PaginationParams withSize(int newSize) =>
      PaginationParams(page: page, size: newSize);

  final int page;
  final int size;

  @override
  List<Object?> get props => [page, size];

  @override
  String toString() => 'PaginationParams(page: $page, size: $size)';
}

/// Immutable query object encapsulating all broadcast query parameters
/// Following the Query Object pattern from DDD
final class BroadcastQuery with EquatableMixin {
  const BroadcastQuery({
    this.id,
    this.sortParams,
    this.status,
    this.includeTotalListeners = false,
    this.onlySubscriptions = false,
    this.keywords,
    this.creatorId,
    this.pagination = const PaginationParams(),
    this.endTimeRange,
    this.startTimeRange,
    this.type,
  });

  // Now live broadcasts
  factory BroadcastQuery.nowLive({
    PaginationParams pagination = const PaginationParams(size: 8),
  }) => const BroadcastQuery(
    type: BroadcastsType.nowLive,
    sortParams: SortParams.startTimeAsc,
    endTimeRange: TimeRange.notExists(),
    startTimeRange: TimeRange.exists(),
    includeTotalListeners: true,
    status: BroadcastStatus.active,
  ).copyWith(pagination: pagination);

  /// Recently ended broadcasts
  factory BroadcastQuery.recentlyLive({
    PaginationParams pagination = const PaginationParams(size: 8),
  }) => const BroadcastQuery(
    type: BroadcastsType.recentlyLive,
    sortParams: SortParams.endTimeDesc,
    endTimeRange: TimeRange.exists(),
    startTimeRange: TimeRange.exists(),
    includeTotalListeners: true,
  ).copyWith(pagination: pagination);

  /// Broadcasts for the current user (for you page)
  factory BroadcastQuery.forYou({
    PaginationParams pagination = const PaginationParams(),
  }) => const BroadcastQuery(
    type: BroadcastsType.forYou,
    sortParams: SortParams.startTimeDesc,
    includeTotalListeners: true,
  ).copyWith(pagination: pagination);

  /// User's subscriptions
  factory BroadcastQuery.subscriptions({
    SortParams? sortParams,
    PaginationParams pagination = const PaginationParams(),
  }) => BroadcastQuery(
    onlySubscriptions: true,
    sortParams: sortParams ?? SortParams.startTimeDesc,
    pagination: pagination,
  );

  /// Broadcasts by specific creator
  factory BroadcastQuery.byCreator({
    required Id creatorId,
    BroadcastStatus? status,
    SortParams? sortParams,
    PaginationParams pagination = const PaginationParams(),
  }) => BroadcastQuery(
    creatorId: creatorId,
    status: status,
    sortParams: sortParams ?? SortParams.startTimeDesc,
    pagination: pagination,
  );

  /// Search broadcasts by keywords
  factory BroadcastQuery.search({
    required String keywords,
    BroadcastStatus? status,
    PaginationParams pagination = const PaginationParams(),
  }) => BroadcastQuery(
    keywords: keywords,
    status: status,
    sortParams: SortParams.startTimeDesc,
    pagination: pagination,
  );

  factory BroadcastQuery.fromRouter(Map<String, String> map) {
    return BroadcastQuery(
      type: map['type'] is String
          ? BroadcastsType.values.firstWhere((e) => e.value == map['type'])
          : null,
      id: map['id'] != null ? Id.fromString(map['id']!) : null,
      sortParams: SortParams(
        sortBy: map['sortBy'] is String
            ? SortBy.values.firstWhere((e) => e.value == map['sortBy'])
            : SortBy.title,
        orderBy: map['orderBy'] is String
            ? OrderBy.values.firstWhere((e) => e.value == map['orderBy'])
            : OrderBy.asc,
      ),
      status: map['status'] is String
          ? BroadcastStatus.values.firstWhere((e) => e.name == map['status'])
          : null,
      creatorId: map['creatorId'] != null
          ? Id.fromString(map['creatorId']!)
          : null,
      keywords: map['keywords'],
      includeTotalListeners: map['totalListeners'] != null,
      onlySubscriptions: switch (map['onlySubscriptions']) {
        'true' => true,
        _ => false,
      },
      pagination: PaginationParams(
        page: int.tryParse(map['page']!) ?? 1,
        size: int.tryParse(map['size']!) ?? 20,
      ),
      endTimeRange: TimeRange(
        exists: switch (map['endTime[exist]']) {
          'true' => true,
          _ => false,
        },
        gt: map['endTime[gt]'],
        lt: map['endTime[lt]'],
      ),
      startTimeRange: TimeRange(
        exists: switch (map['startTime[exist]']) {
          'true' => true,
          _ => false,
        },
        gt: map['startTime[gt]'],
        lt: map['startTime[lt]'],
      ),
    );
  }

  final Id? id;
  final SortParams? sortParams;
  final BroadcastStatus? status;
  final bool includeTotalListeners;
  final bool onlySubscriptions;
  final String? keywords;
  final Id? creatorId;
  final PaginationParams pagination;
  final TimeRange? endTimeRange;
  final TimeRange? startTimeRange;
  final BroadcastsType? type;

  bool get hasFilters =>
      id != null ||
      status != null ||
      keywords != null ||
      creatorId != null ||
      onlySubscriptions ||
      (endTimeRange?.hasFilter ?? false) ||
      (startTimeRange?.hasFilter ?? false);

  bool get isSearch => keywords != null && keywords!.isNotEmpty;

  /// Creates a copy with modified parameters
  BroadcastQuery copyWith({
    SortParams? sortParams,
    Id? id,
    BroadcastStatus? status,
    bool? includeTotalListeners,
    bool? onlySubscriptions,
    String? keywords,
    Id? creatorId,
    PaginationParams? pagination,
    TimeRange? endTimeRange,
    TimeRange? startTimeRange,
    BroadcastsType? type,
  }) => BroadcastQuery(
    sortParams: sortParams ?? this.sortParams,
    id: id ?? this.id,
    status: status ?? this.status,
    includeTotalListeners: includeTotalListeners ?? this.includeTotalListeners,
    onlySubscriptions: onlySubscriptions ?? this.onlySubscriptions,
    keywords: keywords ?? this.keywords,
    creatorId: creatorId ?? this.creatorId,
    pagination: pagination ?? this.pagination,
    endTimeRange: endTimeRange ?? this.endTimeRange,
    startTimeRange: startTimeRange ?? this.startTimeRange,
    type: type ?? this.type,
  );

  /// Navigate to next page
  BroadcastQuery nextPage() => copyWith(pagination: pagination.next());

  /// Navigate to previous page
  BroadcastQuery previousPage() => copyWith(pagination: pagination.previous());

  /// Reset to first page (useful after filtering)
  BroadcastQuery resetPage() => copyWith(pagination: pagination.reset());

  /// Update search keywords and reset to first page
  BroadcastQuery updateKeywords(String? newKeywords) =>
      copyWith(keywords: newKeywords, pagination: pagination.reset());

  @override
  List<Object?> get props => [
    id,
    sortParams,
    status,
    includeTotalListeners,
    onlySubscriptions,
    keywords,
    creatorId,
    pagination,
    endTimeRange,
    startTimeRange,
    type,
  ];

  @override
  String toString() =>
      '''
BroadcastQuery(
  id: $id,
  sortParams: $sortParams,
  status: $status,
  includeTotalListeners: $includeTotalListeners,
  onlySubscriptions: $onlySubscriptions,
  keywords: $keywords,
  creatorId: $creatorId,
  pagination: $pagination,
  endTimeRange: $endTimeRange,
  startTimeRange: $startTimeRange
  type: $type,
)''';

  // ========================================================================
  // PRIVATE PARSING HELPERS
  // ========================================================================

  static Id? _parseId(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return Id.fromString(value);
    } catch (_) {
      return null;
    }
  }

  static SortParams? _parseSortParams(Map<String, String> params) {
    final sortBy = SortBy.fromString(params['sortBy']);
    final orderBy = OrderBy.fromString(params['orderBy']);

    if (sortBy == null || orderBy == null) return null;

    return SortParams(sortBy: sortBy, orderBy: orderBy);
  }

  static BroadcastStatus? _parseBroadcastStatus(String? value) {
    if (value == null) return null;
    try {
      return BroadcastStatus.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }

  static PaginationParams _parsePagination(Map<String, String> params) {
    final page = int.tryParse(params['page'] ?? '');
    final size = int.tryParse(params['size'] ?? '');
    return PaginationParams(
      page: page ?? 1,
      size: size ?? PaginationParams.defaultSize,
    );
  }

  static TimeRange? _parseTimeRange(Map<String, String> params, String prefix) {
    final gt = params['$prefix[gt]'];
    final lt = params['$prefix[lt]'];
    final exists = params['$prefix[exist]'];

    // If no time range parameters, return null
    if (gt == null && lt == null && exists == null) return null;

    return TimeRange(
      gt: gt,
      lt: lt,
      exists: switch (exists) {
        'true' => true,
        _ => false,
      },
    );
  }
}

extension BroadcastQueryMapper on BroadcastQuery {
  /// Convert to API query parameters (for HTTP requests)
  Map<String, dynamic> get toApiParams {
    final params = <String, dynamic>{
      // Basic fields
      if (id != null) 'id': id!.getOrCrash(),
      if (status != null) 'status': status!.name,
      if (creatorId != null) 'creatorId': creatorId!.getOrCrash(),
      if (keywords != null && keywords!.isNotEmpty) 'keywords': keywords,
      if (includeTotalListeners) 'include': 'totalListeners',
      if (onlySubscriptions) 'onlySubscriptions': true,

      // Sorting & pagination
      if (sortParams != null) ...{
        'sortBy': sortParams!.sortBy.value,
        'orderBy': sortParams!.orderBy.value,
      },
      'page': pagination.page,
      'size': pagination.size,

      // Time ranges
      ..._serializeTimeRange('startTime', startTimeRange),
      ..._serializeTimeRange('endTime', endTimeRange),
    };

    // Remove null values
    return params..removeWhere((key, value) => value == null);
  }

  /// Convert to router query parameters (for navigation)
  Map<String, String> get toRouterParams {
    final params = <String, String>{
      // Basic fields
      if (type != null) 'type': type!.value,
      if (id != null) 'id': id!.getOrCrash(),
      if (status != null) 'status': status!.name,
      if (creatorId != null) 'creatorId': creatorId!.getOrCrash(),
      if (keywords != null && keywords!.isNotEmpty) 'keywords': keywords!,
      if (includeTotalListeners) 'include': 'totalListeners',
      if (onlySubscriptions) 'onlySubscriptions': 'true',

      // Sorting & pagination
      if (sortParams != null) ...{
        'sortBy': sortParams!.sortBy.value,
        'orderBy': sortParams!.orderBy.value,
      },
      'page': pagination.page.toString(),
      'size': pagination.size.toString(),

      // Time ranges
      ..._serializeTimeRangeForRouter('startTime', startTimeRange),
      ..._serializeTimeRangeForRouter('endTime', endTimeRange),
    };

    // Remove empty values
    return params..removeWhere((key, value) => value.isEmpty);
  }

  /// Helper to serialize time range for API
  Map<String, dynamic> _serializeTimeRange(String prefix, TimeRange? range) {
    if (range == null || range.isEmpty) return {};

    return {
      if (range.gt != null) '$prefix[gt]': range.gt,
      if (range.lt != null) '$prefix[lt]': range.lt,
      if (range.exists != null) '$prefix[exist]': range.exists,
    };
  }

  /// Helper to serialize time range for router
  Map<String, String> _serializeTimeRangeForRouter(
    String prefix,
    TimeRange? range,
  ) {
    if (range == null || range.isEmpty) return {};

    return {
      if (range.gt != null) '$prefix[gt]': range.gt!,
      if (range.lt != null) '$prefix[lt]': range.lt!,
      if (range.exists != null) '$prefix[exist]': range.exists.toString(),
    };
  }
}
