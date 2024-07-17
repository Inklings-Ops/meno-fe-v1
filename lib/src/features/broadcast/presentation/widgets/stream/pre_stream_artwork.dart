import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class PreStreamArtwork extends StatelessWidget {
  const PreStreamArtwork({super.key,this.imageUrl});
  final String? imageUrl;


  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    final hasImage = imageUrl != null;

    DecorationImage? image;

    if (hasImage) {
      image = DecorationImage(
        image: CachedNetworkImageProvider(
          imageUrl!,
          maxHeight: 240,
          maxWidth: 240,
        ),
        fit: BoxFit.cover,
      );
    }

    final SizedBox placeholder = SizedBox(
      height: (142 * 0.4).h,
      child: colors.brightness == Brightness.light
          ? Assets.images.logoDark.svg()
          : Assets.images.logoLight.svg(),
    );

    return Container(
      height: 142.r,
      width: 142.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16).r,
        border: Border.all(color: colors.outlineVariant1!),
        image: image,
      ),
      child: hasImage ? null : Center(child: placeholder),
    );
  }
}
