import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

class UserAccountDetails extends StatelessWidget {
  final VoidCallback? action;
  const UserAccountDetails({super.key, this.action});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        partiallyAuthenticated: (user) => _Widget(action: action, user: user),
        authenticated: (user, token) => _Widget(action: action, user: user),
      ),
    );
  }
}

class _Widget extends StatelessWidget {
  const _Widget({required this.action, required this.user});

  final VoidCallback? action;
  final User user;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return SizedBox(
      height: 74,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: action != null
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.center,
              children: [
                MText(
                  'Welcome back,',
                  style: textTheme.subheadingMedium,
                ),
                MText(
                  user.fullName.getOr(),
                  style: textTheme.heading2Medium,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: action,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MAvatar(radius: 24, url: user.imageUrl),
                if (action != null) ...[
                  Spaces.verticalMicro,
                  MText(
                    'Switch account',
                    style: textTheme.captionMedium,
                    color: MColorScheme.of(context)?.primary,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
