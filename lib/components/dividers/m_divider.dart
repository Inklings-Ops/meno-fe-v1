import 'package:flutter/material.dart';

class MDivider extends StatelessWidget {
  final double? topSpace;
  final double? bottomSpace;

  final double? start;
  final double? end;

  const MDivider({
    super.key,
    this.topSpace,
    this.bottomSpace,
    this.start,
    this.end,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: topSpace),
          Divider(endIndent: end, indent: start),
          SizedBox(height: bottomSpace),
        ],
      );
}
