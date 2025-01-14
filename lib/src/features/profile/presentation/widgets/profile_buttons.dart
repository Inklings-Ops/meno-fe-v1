import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({super.key});

  @override
  Widget build(BuildContext context) {
    const shape = RoundedRectangleBorder(borderRadius: Corners.sm);
    final textStyle = MTextTheme.of(context)!.microMedium;
    final profile = context.select<MyProfileCubit, Profile?>(
      (bloc) => bloc.state.whenOrNull(
        success: (profile) => profile,
      ),
    );
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Expanded(
            child: MPrimaryButton.icon(
              label: 'Edit profile',
              icon: const Icon(MIcons.edit_05),
              onPressed: () => router.push(
                Routes.editProfileModal,
                extra: profile,
              ),
              style: ElevatedButton.styleFrom(
                textStyle: textStyle,
                shape: shape,
              ),
            ),
          ),
          Spaces.horizontalLarge,
          const Expanded(child: ShareProfileButton()),
        ],
      ),
    );
  }
}
