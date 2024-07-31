import 'package:meno_fe_v1/meno.dart';

class BroadcastListWidget extends StatelessWidget {
  final NullableIndexedWidgetBuilder itemBuilder;
  final int itemCount;

  const BroadcastListWidget({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: const EdgeInsets.symmetric(horizontal: Insets.large),
      separatorBuilder: (context, i) => const SizedBox(width: 24),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
