import 'package:meno_fe_v1/meno.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) => switch (state) {
        SessionAuthenticated(:final user) => MAppBar.home(
            title: user.fullName.getOrCrash(),
            avatarImageUrl: user.imageUrl,
            onAvatarTap: () => router.go(Routes.myProfile),
            onNotificationBellTap: () => router.push(Routes.notifications),
          ),
        _ => const SizedBox(),
      },
    );
  }

  @override
  Size get preferredSize => ToolBarHeights.home;
}
