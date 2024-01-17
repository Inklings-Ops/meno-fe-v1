import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

enum ToastType { error, success }

class NetworkToast extends StatelessWidget {
  final ToastType type;
  const NetworkToast({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;
    final isError = type == ToastType.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8).r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MCore.small).r,
        color: isError ? colorScheme.error : colorScheme.success,
      ),
      child: MText(
        isError ? 'No internet connection' : 'Back online',
        style: MTextStyle.captionRegular,
        color: isError ? colorScheme.onError : colorScheme.onSuccess,
      ),
    );
  }
}
