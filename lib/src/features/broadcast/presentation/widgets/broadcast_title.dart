import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastTitle extends ConsumerWidget {
  final String title;
  const BroadcastTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12).r,
      child: MText(
        title,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: MTextStyle.subheadingBold,
      ),
    );
  }
}
