import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastArtworkWidget extends StatelessWidget {
  const BroadcastArtworkWidget({
    required this.imageUrl,
    this.radius = 48,
    this.outerBoxHeight = 144,
    this.outerBoxWidth = 152,
    this.boxPadding = const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    super.key,
  });

  final String? imageUrl;
  final double radius;
  final double? outerBoxHeight;
  final double? outerBoxWidth;
  final EdgeInsetsGeometry? boxPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: outerBoxHeight,
      width: outerBoxWidth,
      padding: boxPadding,
      alignment: Alignment.center,
      child: MAvatar(radius: radius, url: imageUrl),
    );
  }
}
