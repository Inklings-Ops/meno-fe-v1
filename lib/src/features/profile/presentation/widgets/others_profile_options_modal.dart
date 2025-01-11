
import 'package:meno_fe_v1/meno.dart';

class OthersProfileOptionsModal extends HookWidget {
  const OthersProfileOptionsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return MModal(
      builder: (context) => const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MModalListTile(
            leading: Icon(MIcons.user),
            title: 'Go to profile',
          ),
          Spaces.verticalSmall,
          MModalListTile(
            leading: Icon(MIcons.bell),
            title: 'Turn on notifications',
          ),
          Spaces.verticalLarge,
        ],
      ),
    );
  }
}
