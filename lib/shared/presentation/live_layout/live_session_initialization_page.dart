import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/app/router/router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/shared/presentation/widgets/error_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveSessionInitializationPage extends WatchingWidget {
  const LiveSessionInitializationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final snapshot = watchFuture<GetIt, void>(
      (getIt) => getIt.allReady(timeout: const Duration(seconds: 30)),
      target: di,
      initialValue: null,
    );

    if (snapshot.hasError) return MenoErrorWidget(error: snapshot.error);

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Scaffold(body: Center(child: MLoadingIndicator(100, 100)));
    }

    callOnceAfterThisBuild((ctx) async {
      final router = di<MenoRouter>().routerConfig;
      await router.replace<void>(R.broadcastTab);
    });

    return const SizedBox.shrink();
  }
}
