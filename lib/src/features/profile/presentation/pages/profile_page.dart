import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

class ProfilePage extends StatelessWidget {
  final String? id;
  const ProfilePage({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    if (id != null) {
      return Scaffold(
        body: Center(
          child: Text(id!, style: $styles.text.heading1Bold),
        ),
      );
    } else {
      return const MyProfilePage();
    }
  }
}
