import 'package:meno_fe_v1/meno.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;
    final session = context.read<SessionBloc>();
    final user = session.state.whenOrNull(authenticated: (user, _) => user);
    final fullName = user?.fullName.getOrE('');
    return AlertDialog(
      title: MText(
        'Log out from account?',
        style: textTheme.heading2Regular,
      ),
      contentPadding: const EdgeInsets.all(24),
      content: MText(
        'You are about to log out from $fullName',
        style: textTheme.captionRegular,
      ),
      actions: [
        SizedBox.fromSize(
          size: const Size(85, 40),
          child: MTextButton(
            label: 'Cancel',
            onPressed: () => context.pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colors.onDisabled?.withValues(alpha: 0.5),
              shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: MPrimaryButton(
            label: 'Log out',
            loading: session.state is SessionLoading,
            onPressed: () => session.add(const SessionLogout()),
            style: FilledButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
            ),
          ),
        ),
      ],
    );
  }
}
