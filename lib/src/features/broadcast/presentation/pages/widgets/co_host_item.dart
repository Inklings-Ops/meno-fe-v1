import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';

class CoHostItem extends StatelessWidget {
  final User? user;
  final VoidCallback? onTap;
  final bool isCohost;
  const CoHostItem({super.key, this.user, this.onTap, this.isCohost = false});

  @override
  Widget build(BuildContext context) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;

    final bool hasUser = user != null;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 76,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              fit: StackFit.loose,
              children: [
                MAvatar(
                  radius: 24,
                  url: user?.imageUrl,
                  child: hasUser
                      ? null
                      : Icon(
                          MIcons.users_plus,
                          color: colorScheme.onBackground,
                          size: 16,
                        ),
                ),
                if (hasUser)
                  Positioned(
                    left: 30,
                    top: 30,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: colorScheme.background!,
                        ),
                      ),
                      child: Icon(
                        MIcons.x_close,
                        size: 8,
                        color: colorScheme.onError,
                      ),
                    ),
                  ),
              ],
            ),
            MSize.verticalSpaceSmall,
            MText(
              hasUser ? user!.fullName.get()! : "Add Co-host",
              style: MTextStyle.microMedium,
              color: hasUser ? null : MColor.grey50,
            ),
            if (isCohost) ...[
              MSize.verticalSpaceMicro,
              const MText("Co-host", style: MTextStyle.nanoRegular),
            ],
          ],
        ),
      ),
    );
  }
}
