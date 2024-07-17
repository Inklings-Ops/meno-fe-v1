import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class BroadcastControls extends StatelessWidget {
  const BroadcastControls({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BroadcastMicrophoneButton(),
          MCore.small.horizontalSpace,
          const BroadcastStartStopButton(),
          MCore.small.horizontalSpace,
          const MoreOptionsButton(),
        ],
      ),
    );
  }
}

class MoreOptionsButton extends StatelessWidget {
  const MoreOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return IconButton.outlined(
      icon: const Icon(MIcons.dots_horizontal),
      iconSize: 20,
      color: colors.onBackground,
      style: IconButton.styleFrom(
        fixedSize: Size.fromWidth(48.r),
        side: BorderSide(color: colors.outlineVariant3!),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(MCore.large)),
        ),
      ),
      onPressed: () => context.showModal(
        BlocBuilder<BroadcastBloc, BroadcastState>(
          builder: (context, state) => state.maybeWhen(
            orElse: () => const SizedBox(),
            startSuccess: (b, _) => BroadcastInfoModal(broadcast: b),
          ),
        ),
        isScrollControlled: true,
      ),
    );
  }
}
