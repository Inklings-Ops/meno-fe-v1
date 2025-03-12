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
    final textTheme = MTextTheme.of(context)!;

    final isSubscribedToUser = profile.isSubscribedToUser ?? false;
    final subscribed = profile.subscribed ?? false;
    final effectiveSubscriptionStatus = isSubscribedToUser || subscribed;
    final isSubscribed = useState(effectiveSubscriptionStatus);

    final defaultStyle = OutlinedButton.styleFrom(
      textStyle: textTheme.microMedium,
      fixedSize: const Size(double.infinity, Insets.xxl),
      side: BorderSide(color: MColorScheme.of(context).primary!),
      shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
      backgroundColor: isSubscribed.value ? colors.primary : Colors.transparent,
      foregroundColor: isSubscribed.value ? colors.onPrimary : colors.primary,
    );

    final icon = Icon(
      isSubscribed.value ? MIcons.user_minus_01 : MIcons.user_check,
      color: isSubscribed.value ? colors.onPrimary : colors.primary,
    );

    final label = isSubscribed.value ? 'Unsubscribe' : 'Subscribe';

    final bloc = context.watch<SubscriptionBloc>();

    void handleSubscription() {
      isSubscribed.value = !isSubscribed.value;
      if (isSubscribed.value) {
        bloc.add(Unsubscribe(profile));
      } else {
        bloc.add(Subscribe(profile));
      }
    }
    return BlocListener<SubscriptionBloc, SubscriptionState>(
      listener: (context, state) {
        if (state.exception != null &&
            isSubscribed.value != effectiveSubscriptionStatus) {
          isSubscribed.value = effectiveSubscriptionStatus;
        }
      },
      child: Skeleton.unite(
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
      ),
    );
  }
}
