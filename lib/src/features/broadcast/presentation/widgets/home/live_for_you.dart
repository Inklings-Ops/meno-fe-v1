import 'package:meno_fe_v1/meno.dart';

class LiveForYou extends StatelessWidget {
  const LiveForYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MHeader(title: 'Live For You ✨'),
        Container(
          height: 112.toScale,
          padding: EdgeInsets.symmetric(horizontal: $styles.insets.large),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MText(
                      'Hello there! You are not subscribed to any broadcasts yet.',
                      maxLines: 2,
                      style: $styles.text.captionRegular,
                      color: MColorScheme.of(context)?.onDisabledContainer,
                    ),
                    $styles.spaces.verticalLarge,
                    const DiscoverButton(),
                  ],
                ),
              ),
              20.hSpace,
              Assets.images.liveForYou.image(
                height: 112.toScale,
                width: 112.toScale,
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
    return SizedBox(
      height: 32.toScale,
      width: 112.toScale,
      child: MSecondaryButton(
        label: 'Discover',
        onPressed: () => context.go(Routes.discover),
        style: OutlinedButton.styleFrom(
          textStyle: $styles.text.microMedium,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: $styles.radius.small),
        ),
      ),
    );
  }
}
