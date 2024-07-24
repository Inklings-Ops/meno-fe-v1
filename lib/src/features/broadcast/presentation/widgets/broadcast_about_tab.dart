import 'package:meno_fe_v1/meno.dart';

class BroadcastAboutTab extends StatelessWidget {
  const BroadcastAboutTab({super.key, required this.description});
  final String? description;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: $styles.insets.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(MIcons.menu_03, size: $styles.insets.large),
              $styles.spaces.horizontalSmall,
              MText(
                'About Broadcast',
                style: $styles.text.subheadingMedium,
              ),
            ],
          ),
          $styles.spaces.verticalLarge,
          if (description != null)
            MText(
              description!,
              color: MColorScheme.of(context)!.onDisabledContainer,
            ),
        ],
      ),
    );
  }
}
