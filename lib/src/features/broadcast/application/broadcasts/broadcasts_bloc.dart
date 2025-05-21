import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart' show User;
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/shared/constants/constants.dart' show OrderBy;
import 'package:meno_fe_v1/src/shared/shared.dart' show Uid;

part 'broadcasts_event.dart';
part 'broadcasts_state.dart';

class BroadcastsBloc extends Bloc<BroadcastsEvent, BroadcastsState> {
  BroadcastsBloc({required IBroadcastFacade facade})
      : _facade = facade,
        super(const BroadcastsState()) {
    on<BroadcastsFetchRequested>(_onBroadcastsFetchRequested);
    on<BroadcastsFetchMoreRequested>(_onBroadcastsFetchMoreRequested);
  }

  final IBroadcastFacade _facade;

  Future<void> _onBroadcastsFetchRequested(
    BroadcastsFetchRequested event,
    Emitter<BroadcastsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BroadcastsStateStatus.loading,
        sortBy: event.sortBy,
        orderBy: event.orderBy,
        creatorId: event.creatorId,
        endTimeExists: event.endTimeExists,
        id: event.id,
        include: event.include,
        keywords: event.keywords,
        startTimeExists: event.startTimeExists,
        broadcastStatus: event.status,
      ),
    );

    final response = await _facade.getBroadcasts(
      page: event.page,
      sortBy: event.sortBy,
      orderBy: event.orderBy.name,
      creatorId: event.creatorId?.getOr(),
      endTimeExist: event.endTimeExists,
      id: event.id?.getOr(),
      include: event.include,
      keywords: event.keywords,
      startTimeExist: event.startTimeExists,
      status: event.status,
    );

    emit(
      response.fold(
        (exception) => state.copyWith(
          status: BroadcastsStateStatus.failure,
          exception: exception,
        ),
        (success) => state.copyWith(
          status: BroadcastsStateStatus.success,
          broadcasts: success.broadcasts,
          currentPage: success.currentPage,
          totalPages: success.totalPages,
          hasMore: success.currentPage < success.totalPages,
        ),
      ),
    );
  }

  Future<void> _onBroadcastsFetchMoreRequested(
    BroadcastsFetchMoreRequested event,
    Emitter<BroadcastsState> emit,
  ) async {
    if (state.status.isSuccess || state.broadcasts.isNotEmpty) {
      emit(state.copyWith(status: BroadcastsStateStatus.loadingMore));

      final response = await _facade.getBroadcasts(
        page: state.currentPage + 1,
        sortBy: state.sortBy,
        orderBy: state.orderBy.name,
        creatorId: state.creatorId?.getOr(),
        endTimeExist: state.endTimeExists,
        id: state.id?.getOr(),
        include: state.include,
        keywords: state.keywords,
        startTimeExist: state.startTimeExists,
        status: state.broadcastStatus,
      );

      emit(
        response.fold(
          (exception) => state.copyWith(
            status: BroadcastsStateStatus.failure,
            exception: exception,
          ),
          (success) => state.copyWith(
            status: BroadcastsStateStatus.success,
            broadcasts: success.broadcasts,
            currentPage: success.currentPage,
            totalPages: success.totalPages,
            hasMore: success.currentPage < success.totalPages,
          ),
        ),
      );
    }
  }

  void _onBroadcastsKeywordsChanged(
    BroadcastsKeywordsChanged event,
    Emitter<BroadcastsState> emit,
  ) {
    if (state.status.isSuccess) {
      emit(state.copyWith(keywords: event.keywords));
    }
  }
}
