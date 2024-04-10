import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';


import '../../features/auth/application/application.dart';
import '../../features/auth/domain/domain.dart';
import '../../router/router.dart';

class MSwitchAccountModal extends StatelessWidget {
  const MSwitchAccountModal({super.key});


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AccountCubit, AccountState>(
      listener: (context, state) {
        state.option.fold(
          () => null,
          (either) => either.fold(
            (failure) => failure.mapOrNull(
              userTokenExpired: (_) => context.go(Routes.login),
            ),
            (r) => null,
          ),
        );
      },
      builder: (context, state) {
        if (state.allCredentials.length == 1) {
          return const _SwitchAccountModal1();
        } else {
          return const _SwitchAccountModal2();
        }
      },
    );
  }
}

class _AccountListTile extends StatelessWidget {
  final UserCredential credentials;

  const _AccountListTile({required this.credentials});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => state.maybeMap(
        orElse: () => const SizedBox(),
        authenticated: (v) => buildRadioTile(context, v.credentials),
        partiallyAuthenticated: (v) => buildRadioTile(context, v.credentials),
      ),
    );
  }

  Widget buildRadioTile(BuildContext context, UserCredential auth) {
    final user = credentials.user;
    return RadioListTile<UserCredential>(
      key: ObjectKey(auth),
      value: credentials,
      groupValue: auth,
      onChanged: (value) {
        context.read<AccountCubit>().switchAccount(value);
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
            user.fullName.get()!,
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
    final colorScheme = MColorScheme.of(context)!;

    return InkWell(
      onTap: () {
        context.pop();
        context.read<AuthBloc>().add(const AuthLogoutRequested());
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
                color: colorScheme.primary,
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
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.go(Routes.login);
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
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) => MModal(
        title: 'Switch Account',
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...state.allCredentials.map(
              (credentials) => _AccountListTile(credentials: credentials),
            ),
            const SizedBox(height: 24),
            const _AddAccountTile(),
          ],
        ),
      ),
    );
  }
}
