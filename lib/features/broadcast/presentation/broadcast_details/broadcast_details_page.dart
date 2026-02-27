import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/domain/i_broadcast_repository.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

class BroadcastDetailsPage extends WatchingWidget {
  const BroadcastDetailsPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    pushScope(
      init: (getIt) {
        getIt.registerLazySingletonAsync(() async {
          return BroadcastDetailsManager(
            repository: di<IBroadcastRepository>(),
            broadcastId: Id.fromString(id),
          );
        }, onCreated: (instance) => instance.fetch.run());
      },
    );

    return const _BroadcastDetailsContent(key: Key('BroadcastDetailsContent'));
  }
}

class _BroadcastDetailsContent extends StatelessWidget {
  const _BroadcastDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
