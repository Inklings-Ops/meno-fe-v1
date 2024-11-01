import 'package:logger/logger.dart';
import 'package:meno_fe_v1/meno.dart';

class MenoBlocObserver extends BlocObserver {
  const MenoBlocObserver({required this.log});
  final Logger log;

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    log.i('$bloc has been created');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    log.f('$bloc Event → $event');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    log.w('$bloc: ${transition.currentState} → ${transition.nextState}');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log.e('$bloc Error: $error\n StackTrace: $stackTrace');
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    log.t('$bloc is closed');
  }
}
