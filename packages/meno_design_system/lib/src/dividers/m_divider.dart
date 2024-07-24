import 'package:flutter/material.dart';

class MDivider extends StatelessWidget {
  const MDivider({
    super.key,
    this.topSpace,
    this.bottomSpace,
    this.start,
    this.end,
  });
  final double? topSpace;
  final double? bottomSpace;
  final double? start;
  final double? end;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: topSpace),
          Divider(endIndent: end, indent: start, height: 1),
          SizedBox(height: bottomSpace),
        ],
      );
}
