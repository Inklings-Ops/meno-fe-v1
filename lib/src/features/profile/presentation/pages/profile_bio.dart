import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';
import 'package:readmore/readmore.dart';

class ProfileBio extends StatelessWidget {
  const ProfileBio({super.key, required this.bio});
  final IBio? bio;

  @override
  Widget build(BuildContext context) {
    final style = MTextStyle.captionMedium.copyWith(
      color: MColorScheme.of(context)!.onBackgroundVariant,
    );

    return ReadMoreText(
      bio?.get() ?? 'No bio',
      style: MTextStyle.captionRegular.copyWith(height: 1.3.h),
      trimLines: 3,
      trimMode: TrimMode.Line,
      trimExpandedText: '\nless',
      trimCollapsedText: '\nmore',
      moreStyle: style,
      lessStyle: style,
    );
  }
}
