import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../dependency_injector/injector.dart';
import '../domain/domain.dart';

part 'broadcast_providers.g.dart';

@riverpod
IBroadcastFacade broadcastFacade(BroadcastFacadeRef ref) {
  return di<IBroadcastFacade>();
}
