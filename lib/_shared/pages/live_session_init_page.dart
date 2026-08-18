import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/widgets/meno_error_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// Transition page shown while get_it finishes initialising the live-session
/// scope before navigating to the live broadcast tab.
///
class LiveSessionInitPage extends WatchingWidget {
  const LiveSessionInitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final futureNotifier = createOnce(
      () => ValueNotifier<Future<void>>(
        di.allReady(timeout: const Duration(seconds: 30)),
      ),
    );

    final snapshot = watchFuture<ValueNotifier<Future<void>>, void>(
      (n) => n.value,
      target: futureNotifier,
      initialValue: null,
      allowFutureChange: true,
    );

    if (snapshot.hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: .stretch,
            mainAxisAlignment: .center,
            children: [
              MenoErrorWidget(
                error: snapshot.error,
                onRetry: () async {
                  futureNotifier.value = di.allReady(
                    timeout: const Duration(seconds: 30),
                  );
                },
              ),
              Spaces.verticalLarge,
              Row(
                mainAxisAlignment: .center,
                spacing: 8,
                children: [
                  MTextButton(
                    label: 'Go Home',
                    onPressed: () => context.go(R.home),
                  ),
                  MTextButton(
                    label: 'Back to Broadcast Editor',
                    onPressed: () => context
                      ..go(R.home)
                      ..push(R.broadcastEditor),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (snapshot.connectionState == .waiting) return _buildLoadingView();

    // allReady() completed — navigate to the live broadcast tab.
    // callOnceAfterThisBuild ensures we navigate after layout, not during.
    callOnceAfterThisBuild((_) => context.replace(R.liveBroadcast));

    return _buildLoadingView();
  }

  Widget _buildLoadingView() {
    return const Scaffold(body: Center(child: MLoadingIndicator(100, 100)));
  }
}
