import 'package:meno_fe_v1/meno.dart';

class LiveLoadingIndicatorOverlay extends StatelessWidget {
  const LiveLoadingIndicatorOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.8),
      child: const SizedBox.expand(
        child: Center(child: MLoadingIndicator(130, 130)),
      ),
    );
  }
}
