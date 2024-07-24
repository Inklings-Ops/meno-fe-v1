import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class LiveBibleTab extends StatelessWidget {
  const LiveBibleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: $styles.insets.large),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          ScripturePicker(),
          MDivider(bottomSpace: 16),
          Expanded(child: BibleVerses()),
        ],
      ),
    );
  }
}
