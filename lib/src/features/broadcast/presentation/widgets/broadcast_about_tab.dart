import 'package:meno_fe_v1/meno.dart';

class BroadcastAboutTab extends StatelessWidget {
  const BroadcastAboutTab({required this.description, super.key});
  final String? description;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(MIcons.menu_03, size: Insets.lg),
              Spaces.horizontalSmall,
              MText(
                'About Broadcast',
                style: textTheme.subheadingMedium,
              ),
            ],
          ),
          Spaces.verticalLarge,
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
