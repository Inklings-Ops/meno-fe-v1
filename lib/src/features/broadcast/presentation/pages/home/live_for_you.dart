import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../broadcast/count_down_dialog.dart';

class LiveForYou extends StatelessWidget {
  const LiveForYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MHeader(title: "Live For You ✨"),
        MCore.large.verticalSpace,
        Container(
          height: 112.h,
          padding: const EdgeInsets.symmetric(horizontal: MCore.large).r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MText(
                      "Hello there! You are not subscribed to any broadcasts yet.",
                      maxLines: 2,
                      style: MTextStyle.captionRegular,
                      color: MColorScheme.of(context)?.onDisabledContainer,
                    ),
                    MCore.large.verticalSpace,
                    const DiscoverButton(),
                  ],
                ),
              ),
              20.horizontalSpace,
              Assets.images.liveForYou.image(
                height: 112.r,
                width: 112.r,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DiscoverButton extends StatelessWidget {
  const DiscoverButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.h,
      width: 112.w,
      child: MSecondaryButton(
        label: "Discover",
        // onPressed: () => context.push("/chat"),
        onPressed: () => showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black87,
          builder: (context) => const CountDownDialog(),
        ),
        style: OutlinedButton.styleFrom(
          textStyle: MTextStyle.microMedium,
          padding: EdgeInsets.zero.r,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8).r,
          ),
        ),
      ),
    );
  }
}
