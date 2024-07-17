import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/broadcast_form/broadcast_form_cubit.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

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
          MAvatar(radius: 48.r, file: state.artwork?.getOr()),
          MTextButton(
            label: 'Change Artwork',
            onPressed: () => context.showModal(MImageSourceModal(
              onGallerySourceTap: () => bloc.artworkChanged(true),
              onCameraSourceTap: () => bloc.artworkChanged(false),
            )),
          ),
          Center(
            child: SizedBox(
              width: 167.w,
              child: const MText(
                'JPG or PNG accepted. Max size 10mb.',
                maxLines: 2,
                style: MTextStyle.microRegular,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
