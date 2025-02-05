import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class AddCohostModal extends StatelessWidget {
  const AddCohostModal({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
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
            Spaces.verticalLarge,
            Row(
              children: [
                Icon(
                  MIcons.info_circle,
                  size: 16,
                  color: colors.onBackgroundVariant,
                ),
                Spaces.horizontalMicro,
                MText(
                  'Select not more than 1 co-host',
                  color: colors.onBackgroundVariant,
                ),
              ],
            ),
            Spaces.verticalLarge,
            const CohostListTile(),
            Spaces.verticalXLarge,
            Spaces.verticalLarge,
            MPrimaryButton(label: 'Done', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
