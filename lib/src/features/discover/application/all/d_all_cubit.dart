import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';

part 'd_all_state.dart';
part 'd_all_cubit.freezed.dart';

@lazySingleton
class DAllCubit extends Cubit<DAllState> {
  DAllCubit({required IDiscoverFacade facade})
      : _facade = facade,
        super(DAllState.initial());
  final IDiscoverFacade _facade;

  Future<void> init() async {
    await Future.wait([fetchNowLive(), fetchRecentlyLive()]);
  }

  Future<void> fetchNowLive() async {
    emit(state.copyWith(isNowLiveLoading: true));
    final fOrS = await _facade.fetchNowLive();
    emit(fOrS.fold(
      (f) => state.copyWith(isNowLiveLoading: false),
      (s) => state.copyWith(isNowLiveLoading: false, nowLive: s.broadcasts),
    ),);
  }

  Future<void> fetchRecentlyLive() async {
    emit(state.copyWith(isRecentlyLiveLoading: true));
    final fOrS = await _facade.fetchRecentlyLive();
    emit(fOrS.fold(
      (f) => state.copyWith(isRecentlyLiveLoading: false),
      (s) => state.copyWith(
        isRecentlyLiveLoading: false,
        recentlyLive: s.broadcasts,
      ),
    ),);
  }

  Future<void> refreshNowLive() async {
    emit(state.copyWith(isNowLiveLoading: true));
    final fOrS = await _facade.fetchNowLive();
    emit(fOrS.fold(
      (f) => state.copyWith(isNowLiveLoading: false, nowLive: []),
      (s) => state.copyWith(isNowLiveLoading: false, nowLive: s.broadcasts),
    ),);
  }

  Future<void> refreshRecentlyLive() async {
    emit(state.copyWith(isRecentlyLiveLoading: true));
    final fOrS = await _facade.fetchRecentlyLive();
    emit(fOrS.fold(
      (f) => state.copyWith(isRecentlyLiveLoading: false, recentlyLive: []),
      (s) => state.copyWith(
        isRecentlyLiveLoading: false,
        recentlyLive: s.broadcasts,
      ),
    ),);
  }
}
