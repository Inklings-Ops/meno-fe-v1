part of 'filter_bloc.dart';

sealed class FilterEvent with EquatableMixin {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

final class FilterFetchRequested extends FilterEvent {
  const FilterFetchRequested(this.currentPage);
  final int currentPage;
  @override
  List<Object?> get props => [currentPage];
}

final class FilterChanged extends FilterEvent {
  const FilterChanged(this.filter);
  final Filter filter;
  @override
  List<Object?> get props => [filter];
}

final class FilterRefreshRequested extends FilterEvent {
  const FilterRefreshRequested();
}
