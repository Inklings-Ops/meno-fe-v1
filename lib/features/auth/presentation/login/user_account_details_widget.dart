import 'package:flutter/material.dart';
import 'package:meno/shared/domain/domain.dart';
import 'package:meno_design_system/meno_design_system.dart';

class UserAccountDetailsWidget extends StatelessWidget {
  const UserAccountDetailsWidget({required this.user, super.key, this.action});

  final User user;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
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
                MText('Welcome back,', style: textTheme.subheadingMedium),
                MText(
                  user.fullName.getOrCrash(),
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
                    color: MColorScheme.of(context).primary,
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
