import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({
    required this.profile,
    this.style,
    this.showIcon = false,
    super.key,
  });

  final Profile profile;
  final ButtonStyle? style;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;

    final isSubscribedToUser = profile.isSubscribedToUser ?? false;
    final subscribed = profile.subscribed ?? false;
    final effectiveIsSubcribedToUser = isSubscribedToUser || subscribed;

    final defaultStyle = OutlinedButton.styleFrom(
      textStyle: textTheme.microMedium,
      fixedSize: const Size(double.infinity, Insets.xxl),
      side: BorderSide(color: MColorScheme.of(context).primary!),
      shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
      backgroundColor:
          effectiveIsSubcribedToUser ? colors.primary : Colors.transparent,
      foregroundColor:
          effectiveIsSubcribedToUser ? colors.onPrimary : colors.primary,
    );

    final icon = Icon(
      effectiveIsSubcribedToUser ? MIcons.user_minus_01 : MIcons.user_check,
      color: effectiveIsSubcribedToUser ? colors.onPrimary : colors.primary,
    );

    final label = effectiveIsSubcribedToUser ? 'Unsubscribe' : 'Subscribe';

    return Skeleton.unite(
      child: showIcon
          ? MSecondaryButton.icon(
              label: label,
              icon: icon,
              onPressed: () {},
              style: style ?? defaultStyle,
            )
          : MSecondaryButton(
              label: label,
              onPressed: () {},
              style: style ?? defaultStyle,
            ),
    );
  }
}
