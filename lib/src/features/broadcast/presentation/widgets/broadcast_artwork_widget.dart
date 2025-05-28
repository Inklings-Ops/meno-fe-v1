import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastArtworkWidget extends StatelessWidget {
  const BroadcastArtworkWidget({
    this.radius = 48,
    this.outerBoxHeight = 144,
    this.outerBoxWidth = 152,
    this.boxPadding = const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    super.key,
  });

  final double radius;
  final double? outerBoxHeight;
  final double? outerBoxWidth;
  final EdgeInsetsGeometry? boxPadding;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BroadcastBloc, BroadcastState, String?>(
      selector: (state) => state.broadcast.imageUrl,
      builder: (context, imageUrl) => Container(
        height: outerBoxHeight,
        width: outerBoxWidth,
        padding: boxPadding,
        alignment: Alignment.center,
        child: MAvatar(radius: radius, url: imageUrl),
      ),
    );
  }
}
