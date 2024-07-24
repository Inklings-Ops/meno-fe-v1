import 'package:meno_fe_v1/meno.dart';

enum ToastType { error, success }

class NetworkToast extends StatelessWidget {
  final ToastType type;
  const NetworkToast({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;
    final isError = type == ToastType.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8).radius,
      decoration: BoxDecoration(
        borderRadius: $styles.radius.small,
        color: isError ? colorScheme.error : colorScheme.success,
      ),
      child: MText(
        isError ? 'No internet connection' : 'Back online',
        style: $styles.text.captionRegular,
        color: isError ? colorScheme.onError : colorScheme.onSuccess,
      ),
    );
  }
}
