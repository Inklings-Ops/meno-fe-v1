import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';

part 'd_recently_live_cubit.freezed.dart';
part 'd_recently_live_state.dart';

@lazySingleton
class DRecentlyLiveCubit extends Cubit<DRecentlyLiveState> {
  final IDiscoverFacade _facade;
  DRecentlyLiveCubit({required IDiscoverFacade facade})
      : _facade = facade,
        super(DRecentlyLiveState.initial());

  Future<void> fetch(int page) async {
    if (state.isLoading || !state.hasMore) return;
    emit(state.copyWith(isLoading: true, hasError: false));
    final fOrS = await _facade.fetchRecentlyLive(page: page);
    final currentBroadcasts = [...state.broadcasts];
    emit(fOrS.fold(
      (f) => state.copyWith(isLoading: false, hasError: true),
      (s) => state.copyWith(
        isLoading: false,
        page: s.currentPage,
        hasMore: s.currentPage < s.totalPages,
        broadcasts: [...currentBroadcasts, ...s.broadcasts],
      ),
    ));
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true, hasError: false));
    final fOrS = await _facade.fetchRecentlyLive();
    emit(fOrS.fold(
      (f) => state.copyWith(isLoading: false, hasError: true),
      (s) => state.copyWith(
        isLoading: false,
        page: s.currentPage,
        hasMore: s.currentPage < s.totalPages,
        broadcasts: s.broadcasts,
      ),
    ));
  }
}
