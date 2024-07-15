import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

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
    return SizedBox(
      height: 74.h,
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
                const MText(
                  'Welcome back,',
                  style: MTextStyle.subheadingMedium,
                ),
                MText(
                  user.fullName.getOr(),
                  style: MTextStyle.heading2Medium,
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
                MAvatar(radius: 24.r, url: user.imageUrl),
                if (action != null) ...[
                  MCore.micro.verticalSpace,
                  MText(
                    'Switch account',
                    style: MTextStyle.captionMedium,
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
