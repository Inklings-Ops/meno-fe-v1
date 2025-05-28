import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastCreatorWidget extends StatelessWidget {
  const BroadcastCreatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return BlocSelector<BroadcastBloc, BroadcastState, String>(
      selector: (state) {
        final broadcast = state.broadcast;
        return broadcast.creator?.fullName.getOrNull() ??
            broadcast.creatorFullName?.getOrNull() ??
            broadcast.fullName?.getOrNull() ??
            '';
      },
      builder: (context, creator) => MText(
        creator,
        color: colors.onDisabledContainer,
        style: textTheme.captionRegular,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}
