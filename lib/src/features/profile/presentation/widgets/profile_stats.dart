import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({required this.stats, super.key});
  final UserStats? stats;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Row(
        children: [
          const SizedBox(width: 2),
          ProfileStatItem(title: 'Broadcasts', count: stats?.broadcasts),
          // Spaces.horizontalLarge,
          const Spacer(),
          ProfileStatItem(title: 'Subscribers', count: stats?.subscribers),
          // Spaces.horizontalLarge,
          const Spacer(),
          ProfileStatItem(title: 'Subscriptions', count: stats?.subscriptions),
          const SizedBox(width: 2),
        ],
      ),
    );
  }
}
