import 'package:meno_fe_v1/meno.dart';

class MenoLogo extends StatelessWidget {
  const MenoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    if (isLight) {
      return Assets.images.menoPurple.image(height: 32.toScale);
    } else {
      return Assets.images.menoWhite.image(height: 32.toScale);
    }
  }
}
