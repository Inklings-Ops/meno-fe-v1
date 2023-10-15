import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../auth/domain/domain.dart';
import 'add_cohost_modal.dart';

class CoHostSection extends StatelessWidget {
  const CoHostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 72,
      child: Row(
        children: [
          CoHostItem(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const AddCohostModal(),
            ),
          ),
          MSize.horizontalSpaceSmall,
          const Wrap(
            spacing: 8,
            children: [],
          ),
        ],
      ),
    );
  }
}

class CoHostItem extends StatelessWidget {
  final User? user;
  final VoidCallback? onTap;
  const CoHostItem({super.key, this.user, this.onTap});

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
          mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }
}
