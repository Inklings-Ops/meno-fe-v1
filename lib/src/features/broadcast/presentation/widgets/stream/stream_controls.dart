import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class StreamControls extends StatelessWidget {
  const StreamControls({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const StreamLeaveButton(),
          MCore.small.horizontalSpace,
          const StreamOptionsButton(),
        ],
      ),
    );
  }
}

class StreamOptionsButton extends StatelessWidget {
  const StreamOptionsButton({super.key});
  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return IconButton.outlined(
      icon: const Icon(MIcons.dots_horizontal),
      color: colors.onBackground,
      style: IconButton.styleFrom(
        fixedSize: Size.fromWidth(48.w),
        side: BorderSide(color: colors.outlineVariant3!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MCore.large).r,
        ),
      ),
      onPressed: () => context.showModal(
        BlocBuilder<StreamBloc, StreamState>(
          builder: (context, state) => state.maybeWhen(
            orElse: () => const SizedBox(),
            joinSuccess: (broadcast) => BroadcastInfoModal(
              broadcast: broadcast,
              isStreaming: true,
            ),
          ),
        ),
        isScrollControlled: true,
      ),
    );
  }
}
