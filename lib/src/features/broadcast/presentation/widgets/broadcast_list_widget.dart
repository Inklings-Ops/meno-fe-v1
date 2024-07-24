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
      padding: EdgeInsets.symmetric(horizontal: $styles.insets.large),
      separatorBuilder: (context, i) => 24.hSpace,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
