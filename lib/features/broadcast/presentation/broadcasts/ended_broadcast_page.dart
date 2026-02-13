import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/applications/live_session_manager.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno/shared/presentation/widgets/error_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';

class EndedBroadcastPage extends WatchingWidget {
  const EndedBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final snapshot = watchStream(
      (IBroadcastRepository repo) => repo.onBroadcastEnded,
      initialValue: EndedBroadcast.empty,
    );

    if (snapshot.connectionState == ConnectionState.waiting) {
      return _PageView(broadcast: fakeBroadcasts[0]);
    }

    if (snapshot.hasError) return _ErrorView(error: snapshot.error);

    final data = snapshot.data;
    if (data == null) return const _ErrorView(message: 'No data to display');

    return _PageView(broadcast: data.details);
  }
}

class _PageView extends StatelessWidget {
  const _PageView({required this.broadcast});

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    final manager = di<LiveSessionManager>();
    final broadcast = manager.broadcast;

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
            BroadcastArtworkWidget(imageUrl: broadcast.imageUrl),
            Spaces.verticalLarge,
            BroadcastTimerWidget(
              formattedTime: '',
              showTimeAgo: false,
              textStyle: textTheme.heading2Bold,
            ),
            Spaces.verticalXLarge,
            // const AllParticipantsWidget(),
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
  const _ErrorView({this.error, this.message});

  final Object? error;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      body: Column(
        mainAxisAlignment: .center,
        children: [
          MenoErrorWidget(error: error, message: message),
          Spaces.verticalLarge,
          const _ActionButtons(),
        ],
      ),
    );
  }
}
