import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MUserInfoModal extends StatelessWidget {
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
  final bool loading;
  final String? error;
  final String? fullName;
  final String? bio;
  final String? imageUrl;
  final VoidCallback? onSubscribe;
  final VoidCallback? onViewAccount;

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
            MAvatar(radius: 36.toScale, url: imageUrl),
            $styles.spaces.verticalLarge,
            MText(
              fullName!,
              style: $styles.text.heading3Medium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            if (bio != null) ...[
              $styles.spaces.verticalMicro,
              MText(
                bio!,
                style: $styles.text.subheadingRegular,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
            $styles.spaces.verticalLarge,
            MPrimaryButton.icon(
              label: "Subscribe",
              icon: const Icon(MIcons.user),
              onPressed: onSubscribe,
            ),
            $styles.spaces.verticalSmall,
            MTextButton(label: "View Account", onPressed: onViewAccount),
          ]
        ],
      ),
    );
  }
}
