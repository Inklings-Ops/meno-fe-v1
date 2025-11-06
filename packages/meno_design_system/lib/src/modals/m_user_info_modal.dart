import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A widget that displays a user information modal.
///
/// This modal displays the user's full name, bio (if available), and an image
/// (if provided).
/// It also provides buttons for subscribing to the user (if applicable) and
/// viewing their account.
///
/// The modal can optionally display a loading indicator while fetching user
/// information or an error message if there's an issue retrieving data.
class MUserInfoModal extends StatelessWidget {
  /// Creates a new instance of [MUserInfoModal].
  ///
  /// [fullName] is the user's full name. Required.
  /// [bio] is the user's bio (optional).
  /// [imageUrl] is the URL of the user's image (optional).
  /// [onSubscribe] is a callback function that is called when the user taps
  /// the subscribe button (optional).
  /// [onViewAccount] is a callback function that is called when the user taps
  /// the view account button (optional).
  /// [loading] indicates whether the modal is currently loading user
  /// information (defaults to false).
  /// [error] is an optional error message to display if there's an issue
  /// retrieving user data.
  const MUserInfoModal({
    this.fullName,
    super.key,
    this.bio,
    this.imageUrl,
    this.onSubscribe,
    this.onViewAccount,
    this.loading = false,
    this.error,
  });

  /// Whether the modal is currently loading user information.
  final bool loading;

  /// An optional error message to display if there's an issue retrieving user
  /// data.
  final String? error;

  /// The user's full name.
  final String? fullName;

  /// The user's bio (optional).
  final String? bio;

  /// The URL of the user's image (optional).
  final String? imageUrl;

  /// A callback function that is called when the user taps the subscribe
  /// button (optional).
  final VoidCallback? onSubscribe;

  /// A callback function that is called when the user taps the view account
  /// button (optional).
  final VoidCallback? onViewAccount;

  @override
  Widget build(BuildContext context) {
    return MModal(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!loading && error != null)
            Center(child: MText(error!))
          else ...[
            MAvatar(radius: 36, url: imageUrl, loading: loading),
            Spaces.verticalLarge,
            Skeletonizer(
              enabled: loading,
              child: MText.heading3(
                loading ? BoneMock.name : fullName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            if (bio != null) ...[
              Spaces.verticalMicro,
              Skeletonizer(
                enabled: loading,
                child: MText.subheading(
                  bio!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  weight: MFontWeight.regular,
                ),
              ),
            ],
            Spaces.verticalLarge,
            Skeletonizer(
              enabled: loading,
              child: MPrimaryButton.icon(
                label: 'Subscribe',
                icon: const Icon(MIcons.user),
                onPressed: onSubscribe,
              ),
            ),
            Spaces.verticalSmall,
            Skeletonizer(
              enabled: loading,
              child: MTextButton(
                label: 'View Account',
                onPressed: onViewAccount,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
