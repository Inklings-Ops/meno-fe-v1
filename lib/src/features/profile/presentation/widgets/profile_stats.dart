import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key, required this.stats});
  final UserStats? stats;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46.toScale,
      child: Row(
        children: [
          2.hSpace,
          ProfileStatItem(title: 'Broadcasts', count: stats?.broadcasts),
          $styles.spaces.horizontalLarge,
          ProfileStatItem(title: 'Subscribers', count: stats?.subscribers),
          $styles.spaces.horizontalLarge,
          ProfileStatItem(title: 'Subscriptions', count: stats?.subscriptions),
          2.hSpace,
        ],
      ),
    );
  }
}
