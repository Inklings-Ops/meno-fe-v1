import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MenoEmptyWidget extends StatelessWidget {
  const MenoEmptyWidget({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.liveForYou.image(height: 120, width: 120),
          Spaces.verticalMedium,
          MText(
            title ?? 'Nothing to show here',
            style: MTextTheme.of(context).captionMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
