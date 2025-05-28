import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

class BroadcastAboutTab extends StatelessWidget {
  const BroadcastAboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<BroadcastBloc>();
    return BlocSelector<BroadcastBloc, BroadcastState, MultiLineString>(
      bloc: bloc,
      selector: (state) => bloc.state.broadcast.description,
      builder: (context, description) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MenoSpacer.v(Insets.xl),
            const Row(
              children: [
                Icon(MIcons.menu_03, size: Insets.lg),
                Spaces.horizontalSmall,
                MenoText.subheading(
                  'About Broadcast',
                  weight: MenoFontWeight.bold,
                ),
              ],
            ),
            const MenoSpacer.v(Insets.lg),
            MenoText.caption(
              description.getOrNull() ?? '',
              weight: MenoFontWeight.regular,
            ),
          ],
        ),
      ),
    );
  }
}
