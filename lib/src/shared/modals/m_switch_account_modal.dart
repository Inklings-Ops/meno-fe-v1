import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

import '../../features/auth/application/application.dart';
import '../../features/auth/domain/domain.dart';
import '../../router/router.dart';

class MSwitchAccountModal extends StatelessWidget {
  const MSwitchAccountModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        state.whenOrNull(
          loadFailure: (e) {
            context.showErrorSnackBar('Your token is expired. Login again.');
            context.go(Routes.login);
          },
        );
      },
      builder: (context, state) => state.maybeWhen(
        orElse: () => MModal(
          title: 'Switch Account',
          builder: (context) => const Column(
            mainAxisSize: MainAxisSize.min,
            children: [MLoadingIndicator.box()],
          ),
        ),
        loadSuccess: (allCredentials, _) {
          if (allCredentials.length == 1) {
            return const _SwitchAccountModal1();
          } else {
            return const _SwitchAccountModal2();
          }
        },
      ),
    );
  }
}

class _AccountListTile extends StatelessWidget {
  const _AccountListTile({required this.credential});
  final UserCredential credential;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        authenticated: (user, token) => buildRadioTile(
          context,
          UserCredential.fromUI(user, token),
        ),
        partiallyAuthenticated: (user) => buildRadioTile(
          context,
          UserCredential.fromUI(user),
        ),
      ),
    );
  }

  Widget buildRadioTile(BuildContext context, UserCredential auth) {
    final user = credential.user;
    return RadioListTile<UserCredential>(
      key: ObjectKey(auth),
      value: credential,
      groupValue: auth,
      onChanged: (value) {
        context.read<AccountBloc>().add(AccountSwitchRequested(credential));
        context.pop();
      },
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
      dense: true,
      title: Row(
        children: [
          MAvatar(radius: 20, url: user.imageUrl),
          MCore.large.horizontalSpace,
          MText(
            user.fullName.getOr(),
            style: MTextStyle.bodyRegular,
          ),
        ],
      ),
    );
  }
}

class _AddAccountTile extends StatelessWidget {
  const _AddAccountTile();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return InkWell(
      onTap: () {
        context.pop();
        context.read<SessionCubit>().logout();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: MCore.small,
          horizontal: MCore.large,
        ),
        child: Row(
          children: [
            const Icon(MIcons.plus_circle),
            MCore.medium.horizontalSpace,
            Expanded(
              child: MText(
                'Add Account',
                style: MTextTheme.of(context)?.bodyMedium,
                color: colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchAccountModal1 extends StatelessWidget {
  const _SwitchAccountModal1();

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: 'Switch Account',
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MPrimaryButton(
            label: 'Log in to Existing Account',
            onPressed: () {
              context.pop();
              context.read<SessionCubit>().logout();
            },
          ),
          MTextButton(
            label: 'Create New Account',
            onPressed: () {
              context.pop();
              context.go(Routes.registerWithoutLeading);
            },
          ),
        ],
      ),
    );
  }
}

class _SwitchAccountModal2 extends StatelessWidget {
  const _SwitchAccountModal2();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) => MModal(
        title: 'Switch Account',
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: state.maybeWhen(
            orElse: () => [],
            loadSuccess: (allCredentials, currentCredential) => [
              ...allCredentials.map((c) => _AccountListTile(credential: c)),
              const SizedBox(height: 24),
              const _AddAccountTile(),
            ],
          ),
        ),
      ),
    );
  }
}
