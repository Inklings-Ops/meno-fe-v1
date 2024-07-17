import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

class BroadcastStartStopButton extends HookWidget {
  const BroadcastStartStopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final bloc = context.read<BroadcastBloc>();

    Future<void> stopBroadcast(Uid<Broadcast> broadcastId) {
      return context.showEndBroadcastDialog().then((value) {
        if (value != true) return;
        return bloc.add(BroadcastEndRequested(broadcastId));
      });
    }

    return BlocBuilder<BroadcastBloc, BroadcastState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const _Button(label: 'Start broadcasting'),
        loading: () => const _Button(label: 'Start', loading: true),
        startSuccess: (broadcast, muted) => _Button(
          label: 'Stop broadcasting',
          onTap: () => stopBroadcast(broadcast.id),
          backgroundColor: colors.errorContainer,
          foregroundColor: colors.onErrorContainer,
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.loading = false,
    this.onTap,
  });

  final String label;
  final bool loading;
  final MColor? foregroundColor;
  final MColor? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return MPrimaryButton(
      label: label,
      onPressed: onTap,
      loading: loading,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor ?? colors.onPrimary,
        backgroundColor: (backgroundColor ?? colors.primary)?.withOpacity(0.1),
        fixedSize: Size(160.w, 40.h),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8).r,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MCore.circle).r,
        ),
      ),
    );
  }
}
