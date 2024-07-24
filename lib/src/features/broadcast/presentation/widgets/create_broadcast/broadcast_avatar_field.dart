import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastAvatarField extends StatelessWidget {
  const BroadcastAvatarField({super.key});
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<BroadcastFormCubit>();
    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      bloc: bloc,
      buildWhen: (p, c) => p.artwork != c.artwork,
      builder: (context, state) => Column(
        children: [
          MAvatar(radius: 48.toScale, file: state.artwork?.getOr()),
          MTextButton(
            label: 'Change Artwork',
            onPressed: () => context.showModal(
              MImageSourceModal(
                onGallerySourceTap: () => bloc.artworkChanged(true),
                onCameraSourceTap: () => bloc.artworkChanged(false),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 167.toScale,
              child: MText(
                'JPG or PNG accepted. Max size 10mb.',
                maxLines: 2,
                style: $styles.text.microRegular,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
