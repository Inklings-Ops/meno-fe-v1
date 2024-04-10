import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../application/stream/stream_bloc.dart';
import '../../../domain/domain.dart';
import '../../widgets/broadcast_info_modal.dart';

class StreamControls extends StatelessWidget {
  final Broadcast broadcast;
  const StreamControls({super.key, required this.broadcast});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return SizedBox(
      height: 40.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LeaveButton(),
          MCore.small.horizontalSpace,
          IconButton.outlined(
            onPressed: () => context.showModal(
              BroadcastInfoModal(broadcast: broadcast, isStreaming: true),
              isScrollControlled: true,
            ),
            icon: const Icon(MIcons.dots_horizontal),
            color: colorScheme.onBackground,
            style: IconButton.styleFrom(
              fixedSize: Size.fromWidth(48.w),
              side: BorderSide(color: colorScheme.outlineVariant3!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MCore.large).r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeaveButton extends StatelessWidget {
  const LeaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    final bloc = context.read<StreamBloc>();

    Future<void> leave() async {
      return await context.showLeaveBroadcastDialog().then((value) {
        if (value == true) {
          bloc.add(const StreamEvent.leave());
        }
      });
    }

    return BlocSelector<StreamBloc, StreamState, bool>(
      selector: (state) => state.loading,
      builder: (context, loading) => MPrimaryButton(
        label: 'Leave Broadcast',
        onPressed: leave,
        loading: loading,
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.onBackground,
          backgroundColor: colorScheme.error?.withOpacity(0.5),
          fixedSize: Size(160.w, 40.h),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8).r,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MCore.circle.r),
          ),
        ),
      ),
    );
  }
}
