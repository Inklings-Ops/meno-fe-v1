import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class AddCohostModal extends StatelessWidget {
  const AddCohostModal({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return MModal(
      title: 'Add Co-host',
      builder: (context) => SingleChildScrollView(
        padding: MediaQuery.viewInsetsOf(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MTextFormField(
              label: 'Search',
              prefixIcon: MIcons.search,
              showLabel: false,
              hint: 'Search',
            ),
            $styles.spaces.verticalLarge,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  MIcons.info_circle,
                  size: 16.toScale,
                  color: colors.onBackgroundVariant,
                ),
                $styles.spaces.horizontalMicro,
                MText(
                  'Select not more than 1 co-host',
                  color: colors.onBackgroundVariant,
                ),
              ],
            ),
            $styles.spaces.verticalLarge,
            const CohostListTile(),
            24.vSpace,
            $styles.spaces.verticalLarge,
            MPrimaryButton(label: 'Done', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
