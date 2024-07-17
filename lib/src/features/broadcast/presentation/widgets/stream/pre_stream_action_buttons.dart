import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class PreStreamActionButtons extends HookWidget {
  const PreStreamActionButtons({super.key, required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final loading = useState<bool>(false);
    void onJoin() async {
      loading.value = true;
      return context.read<StreamBloc>().add(StreamJoinRequested(broadcast.id));
    }

    return SizedBox(
      height: 32.h,
      child: Row(
        children: [
          Expanded(
            child: BlocListener<StreamBloc, StreamState>(
              listener: (context, state) {
                state.maybeWhen(
                  orElse: () => loading.value = false,
                  loading: () => loading.value,
                );
              },
              child: _JoinButton(onJoin: onJoin, loading: loading.value),
            ),
          ),
          MCore.small.horizontalSpace,
          Expanded(
            child: MSecondaryButton(
              label: 'Share',
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.outlineVariant3!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8).r,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JoinButton extends StatelessWidget {
  const _JoinButton({
    this.label = 'Join',
    this.onJoin,
    this.loading = false,
    this.disabled = false,
  });
  final String label;
  final bool loading;
  final bool disabled;
  final VoidCallback? onJoin;

  @override
  Widget build(BuildContext context) {
    return MPrimaryButton(
      label: 'Join',
      onPressed: onJoin,
      loading: loading,
      disabled: loading || disabled,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8).r),
      ),
    );
  }
}
