import 'package:meno_fe_v1/meno.dart';

class BroadcastOptionsButton extends StatelessWidget {
  const BroadcastOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return IconButton.outlined(
      icon: const Icon(MIcons.dots_horizontal),
      iconSize: 20,
      color: colors.onBackground,
      style: IconButton.styleFrom(
        fixedSize: const Size.fromWidth(48),
        side: BorderSide(color: colors.outlineVariant3!),
        shape: const RoundedRectangleBorder(borderRadius: Corners.lg),
      ),
      onPressed: () =>
          rootNavigatorKey.currentContext?.push(Routes.broadcastInfoModal),
    );
  }
}
