import 'package:meno_fe_v1/meno.dart'; 

class BroadcastArtworkWidget extends StatelessWidget {
  final String? imageUrl;
  const BroadcastArtworkWidget({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: MAvatar(radius: 48, url: imageUrl),
    );
  }
}
