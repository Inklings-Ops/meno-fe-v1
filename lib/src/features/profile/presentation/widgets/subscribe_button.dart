import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({this.userId, super.key});
  final Uid<User>? userId;

  @override
  Widget build(BuildContext context) {
    return MSecondaryButton.icon(
      label: 'Subscribe',
      icon: const Icon(MIcons.users_check),
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: MColorScheme.of(context).primary!),
        textStyle: MTextTheme.of(context)!.microMedium,
        shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
      ),
    );
  }
}
