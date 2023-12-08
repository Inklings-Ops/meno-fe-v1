import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastArtwork extends ConsumerWidget {
  final String? imageUrl;
  const BroadcastArtwork({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24).r,
      child: MAvatar(radius: 48.r, url: imageUrl),
    );
  }
}
