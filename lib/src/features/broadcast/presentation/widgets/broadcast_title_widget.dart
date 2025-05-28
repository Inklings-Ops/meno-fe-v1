import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastTitleWidget extends StatelessWidget {
  const BroadcastTitleWidget({this.maxLines = 2, super.key});
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return BlocSelector<BroadcastBloc, BroadcastState, SingleLineString>(
      selector: (state) => state.broadcast.title,
      builder: (context, title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.md),
        child: MText(
          title.getOrCrash(),
          maxLines: 2,
          textAlign: TextAlign.center,
          style: textTheme.subheadingBold,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
