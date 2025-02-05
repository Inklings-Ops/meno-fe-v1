import 'package:meno_fe_v1/meno.dart';

class LiveForYou extends StatelessWidget {
  const LiveForYou({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return Column(
      children: [
        const MHeader(title: 'Live For You ✨'),
        Container(
          height: 112,
          padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MText(
                      '''Hello there! You are not subscribed to any broadcasts yet.''',
                      maxLines: 2,
                      style: textTheme.captionRegular,
                      color: MColorScheme.of(context).onDisabledContainer,
                    ),
                    Spaces.verticalLarge,
                    const DiscoverButton(),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Assets.images.liveForYou.image(
                height: 112,
                width: 112,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DiscoverButton extends StatelessWidget {
  const DiscoverButton({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return SizedBox(
      height: 32,
      width: 112,
      child: MSecondaryButton.icon(
        label: 'Discover',
        icon: const Icon(MIcons.compass),
        onPressed: () => router.go(Routes.discover),
        style: OutlinedButton.styleFrom(
          textStyle: textTheme.microMedium,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          shape: const RoundedRectangleBorder(
            borderRadius: Corners.sm,
            side: BorderSide(width: 2),
          ),
        ),
      ),
    );
  }
}
