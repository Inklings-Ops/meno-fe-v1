import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'meno_bloc.freezed.dart';
part 'meno_event.dart';
part 'meno_state.dart';

@lazySingleton
class MenoBloc extends Bloc<MenoEvent, MenoState> {
  MenoBloc() : super(const MenoState.offAir()) {
    on<MenoStateChanged>((event, emit) => emit(state));
  }
}
