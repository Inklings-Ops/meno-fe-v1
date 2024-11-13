import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class EndedBroadcastPage extends StatelessWidget {
  const EndedBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;

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
            const BroadcastArtworkWidget(),
            Spaces.verticalLarge,
            BroadcastTimer(
              showTimeAgo: false,
              textStyle: textTheme.heading2Bold,
            ),
            Spaces.verticalXLarge,
            const AllParticipantsWidget(),
            const SizedBox(height: 40),
            MPrimaryButton(label: 'Publish Broadcast', onPressed: () {}),
            Spaces.verticalLarge,
            Row(
              children: [
                Expanded(
                  child: MSecondaryButton(
                    label: 'Go Home',
                    onPressed: () => router.go(Routes.home),
                  ),
                ),
                Spaces.horizontalMedium,
                Expanded(
                  child: MSecondaryButton(
                    label: 'Go to Profile',
                    onPressed: () => router.go(Routes.myProfile),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
