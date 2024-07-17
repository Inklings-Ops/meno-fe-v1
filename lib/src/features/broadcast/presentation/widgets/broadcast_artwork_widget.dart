import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastArtworkWidget extends StatelessWidget {
  final String? imageUrl;
  const BroadcastArtworkWidget({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24).r,
      child: MAvatar(radius: 48.r, url: imageUrl),
    );
  }
}
