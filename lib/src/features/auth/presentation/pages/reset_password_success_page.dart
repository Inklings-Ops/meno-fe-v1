import 'package:meno_fe_v1/meno.dart';



class ResetPasswordSuccessPage extends StatelessWidget {
  const ResetPasswordSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return MScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.success.image(height: 240, width: 240),
          Spaces.verticalXXXLarge,
          MText(
            'Success!',
            textAlign: TextAlign.center,
            style: textTheme.heading2Bold,
          ),
          Spaces.verticalSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: MText(
              'Your password has been reset, Jim. Phew! That was a close one.',
              textAlign: TextAlign.center,
              maxLines: 3,
              style: textTheme.bodyRegular,
            ),
          ),
          Spaces.verticalXXXLarge,
          MPrimaryButton(
            label: 'Go Back to Log In',
            onPressed: () => router.go(Routes.login),
          ),
        ],
      ),
    );
  }
}
