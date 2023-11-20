import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastListWidget extends StatelessWidget {
  final NullableIndexedWidgetBuilder itemBuilder;
  final int itemCount;

  const BroadcastListWidget({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: const EdgeInsets.symmetric(horizontal: MCore.large),
      separatorBuilder: (context, i) => 24.horizontalSpace,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
