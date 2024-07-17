import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../m_size.dart';

class MUserInfoModal extends StatelessWidget {
  final bool loading;
  final String? error;
  final String? fullName;
  final String? bio;
  final String? imageUrl;
  final VoidCallback? onSubscribe;
  final VoidCallback? onViewAccount;

  const MUserInfoModal({
    super.key,
    this.fullName,
    this.bio,
    this.imageUrl,
    this.onSubscribe,
    this.onViewAccount,
    this.loading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return MModal(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading)
            const MLoadingIndicator.box()
          else if (!loading && error != null)
            Center(child: MText(error!))
          else ...[
            MAvatar(radius: 36, url: imageUrl),
            MSize.verticalSpaceLarge,
            MText(
              fullName!,
              style: MTextStyle.heading3Medium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            if (bio != null) ...[
              MSize.verticalSpaceMicro,
              MText(
                bio!,
                style: MTextStyle.subheadingRegular,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
            MSize.verticalSpaceLarge,
            MPrimaryButton.icon(
              label: "Subscribe",
              icon: const Icon(MIcons.user),
              onPressed: onSubscribe,
            ),
            MSize.verticalSpaceSmall,
            MTextButton(label: "View Account", onPressed: onViewAccount),
          ]
        ],
      ),
    );
  }
}
