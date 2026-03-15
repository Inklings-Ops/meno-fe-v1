import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/widgets/meno_error_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveSessionInitPage extends WatchingWidget {
  const LiveSessionInitPage({super.key});

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

    callOnceAfterThisBuild((ctx) {
      ctx.replace(R.broadcastTab);
    });

    return const Scaffold(body: Center(child: MLoadingIndicator(100, 100)));
  }
}
