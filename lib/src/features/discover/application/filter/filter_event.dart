part of 'filter_bloc.dart';

@freezed
class FilterEvent with _$FilterEvent {
  const factory FilterEvent.fetched(int page) = FilterFetched;
  const factory FilterEvent.filterChanged(Filter filter) = FilterChanged;
  const factory FilterEvent.refreshed() = FilterRefreshed;
}
