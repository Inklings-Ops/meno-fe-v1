import 'package:meno_fe_v1/meno.dart';

class ResetPasswordSuccessPage extends StatelessWidget {
  const ResetPasswordSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.success.image(height: 240.toScale, width: 240.toScale),
          $styles.spaces.verticalXXXLarge,
          MText(
            'Success!',
            textAlign: TextAlign.center,
            style: $styles.text.heading2Bold,
          ),
          $styles.spaces.verticalSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0).radius,
            child: MText(
              'Your password has been reset, Jim. Phew! That was a close one.',
              textAlign: TextAlign.center,
              maxLines: 3,
              style: $styles.text.bodyRegular,
            ),
          ),
          $styles.spaces.verticalXXXLarge,
          MPrimaryButton(
            label: 'Go Back to Log In',
            onPressed: () => context.go(Routes.login),
          ),
        ],
      ),
    );
  }
}
