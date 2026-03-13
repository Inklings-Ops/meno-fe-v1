import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/broadcast/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class EndedBroadcastPage extends WatchingWidget {
  const EndedBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current user ID
    final userId = watchValue((UserManager m) => m.currentUserId);

    // Get summary from repository (user scope - still available!)
    final repository = di<BroadcastLocalService>();
    final summary = repository.getLatestBroadcastSummary(userId);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return context.go(R.home);
      },
      child: summary == null
          ? const _ErrorView(message: 'No broadcast summary available')
          : _PageView(summary: summary),
    );
  }
}

class _PageView extends StatelessWidget {
  const _PageView({required this.summary});

  final BroadcastSummary summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    return MScaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MText(
                'Your live broadcast is complete! Great job.',
                style: textTheme.heading2Bold,
                textAlign: TextAlign.center,
              ),
            ),
            Spaces.verticalXLarge,
            BroadcastArtworkWidget(imageUrl: summary.broadcast.imageUrl),
            Spaces.verticalLarge,
            BroadcastTimerWidget(
              formattedTime: summary.formattedDuration,
              showTimeAgo: false,
              textStyle: textTheme.heading2Bold,
            ),
            Spaces.verticalXLarge,
            EndedBroadcastParticipantsWidget(
              allTimeCount: summary.allTimeParticipants,
              recentParticipants: summary.recentParticipants,
            ),
            const SizedBox(height: 40),
            MPrimaryButton(label: 'Publish Broadcast', onPressed: () {}),
            Spaces.verticalLarge,
            const _ActionButtons(),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MSecondaryButton(
            label: 'Go Home',
            onPressed: () => context.go(R.home),
          ),
        ),
        Spaces.horizontalMedium,
        Expanded(
          child: MSecondaryButton(
            label: 'Go to Profile',
            onPressed: () => context.go(R.myProfile),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      body: Column(
        mainAxisAlignment: .center,
        children: [
          MenoErrorWidget(message: message),
          Spaces.verticalLarge,
          const _ActionButtons(),
        ],
      ),
    );
  }
}
