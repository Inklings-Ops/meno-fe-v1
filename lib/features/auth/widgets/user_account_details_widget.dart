import 'package:flutter/material.dart';
import 'package:meno/_core/value_objects/image_value_objects.dart';
import 'package:meno/_shared/model/entities/user.dart';
import 'package:meno_design_system/meno_design_system.dart';

class UserAccountDetailsWidget extends StatelessWidget {
  const UserAccountDetailsWidget({required this.user, super.key, this.action});

  final User user;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return SizedBox(
      height: 74,
      child: Row(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: action != null ? .end : .center,
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
              crossAxisAlignment: .end,
              mainAxisAlignment: .center,
              children: [
                MAvatar(radius: 24, url: user.image?.getUrl()),
                if (action != null) ...[
                  Spaces.verticalMicro,
                  MText(
                    'Switch account',
                    style: textTheme.captionMedium,
                    color: colors.primary,
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
