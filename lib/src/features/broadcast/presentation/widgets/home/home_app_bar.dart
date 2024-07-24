import 'package:meno_fe_v1/meno.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        authenticated: (user, token) => MAppBar.home(
          title: user.fullName.getOr(),
          avatarImageUrl: user.imageUrl,
          onAvatarTap: () => router.go(Routes.profile),
          onNotificationBellTap: () => router.push(Routes.notifications),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => $styles.toolbarHeight.home;
}
