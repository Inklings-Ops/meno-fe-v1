import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class SubscribeButton extends HookWidget {
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
    final textTheme = MTextTheme.of(context);

    final bloc = context.watch<SubscriptionBloc>();

    final isSubscribedToUser = profile.isSubscribedToUser ?? false;

    final subscribed = (profile.subscribed ?? false) ||
        (bloc.subscribeMap[profile.id] ?? false);

    final isSubscribed = isSubscribedToUser || subscribed;

    final defaultStyle = OutlinedButton.styleFrom(
      textStyle: textTheme.microMedium,
      fixedSize: const Size(double.infinity, Insets.xxl),
      side: BorderSide(color: MColorScheme.of(context).primary),
      shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
      backgroundColor: isSubscribed ? colors.primary : Colors.transparent,
      foregroundColor: isSubscribed ? colors.onPrimary : colors.primary,
    );

    final icon = Icon(
      isSubscribed ? MIcons.user_minus_01 : MIcons.user_check,
      color: isSubscribed ? colors.onPrimary : colors.primary,
    );

    final label = isSubscribed ? 'Unsubscribe' : 'Subscribe';

    void handleSubscription() {
      if (isSubscribed) {
        bloc.add(UnsubscribeRequested(profile));
      } else {
        bloc.add(SubscribeRequested(profile));
      }
    }

    return Skeleton.unite(
      child: showIcon
          ? MSecondaryButton.icon(
              label: label,
              icon: icon,
              onPressed: handleSubscription,
              style: style ?? defaultStyle,
            )
          : MSecondaryButton(
              label: label,
              onPressed: handleSubscription,
              style: style ?? defaultStyle,
            ),
    );
  }
}
