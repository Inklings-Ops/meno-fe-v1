import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../domain/entities/verse.dart';

class VerseWidget extends StatelessWidget {
  const VerseWidget({super.key, required this.verse});

  final Verse verse;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    final reference = '${verse.book} ${verse.chapter}:${verse.verse}';

    return GestureDetector(
      onTap: () {
        context.showModal(
          MModal(
            title: reference,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MModalListTile(
                  leading: Icon(MIcons.send),
                  title: 'Send to chat',
                ),
                MCore.large.verticalSpace,
                const MModalListTile(
                  leading: Icon(MIcons.copy_06),
                  title: 'Copy verse',
                ),
                MCore.large.verticalSpace,
              ],
            ),
          ),
          useRootNavigator: true,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: MCore.small,
              vertical: MCore.micro,
            ).r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MCore.circle),
              color: colorScheme.primaryContainer,
            ),
            child: MText(
              reference,
              style: MTextStyle.microMedium,
              textAlign: TextAlign.center,
            ),
          ),
          MCore.micro.verticalSpace,
          MText(verse.text, style: MTextStyle.bodyRegular),
        ],
      ),
    );
  }
}
