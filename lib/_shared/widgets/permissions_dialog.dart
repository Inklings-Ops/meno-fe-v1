import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// Permission dialog helpers
extension PermissionDialogs on BuildContext {
  /// Show educational rationale for permission
  Future<void> showPermissionRationale(PermissionRationale rationale) async {
    return showDialog<void>(
      context: this,
      barrierDismissible: false,
      builder: (context) => PermissionRationaleDialog(rationale: rationale),
    );
  }

  /// Show settings prompt dialog
  /// Returns true if user wants to open settings
  Future<bool> showPermissionSettingsPrompt(
    PermissionRationale rationale,
  ) async {
    final result = await showDialog<bool>(
      context: this,
      barrierDismissible: false,
      builder: (context) => PermissionSettingsDialog(rationale: rationale),
    );

    return result ?? false;
  }
}

/// Permission rationale dialog
class PermissionRationaleDialog extends StatelessWidget {
  const PermissionRationaleDialog({required this.rationale, super.key});

  final PermissionRationale rationale;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(_getIcon(rationale.permission), color: colors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: MText(rationale.title, style: textTheme.heading3Bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          MText(rationale.message, style: textTheme.bodyMedium),
          const SizedBox(height: 16),
          _buildBenefits(context, rationale.permission),
        ],
      ),
      actions: [
        MTextButton(label: 'Maybe Later', onPressed: context.pop),
        MPrimaryButton(label: 'Got It', onPressed: context.pop),
      ],
    );
  }

  Widget _buildBenefits(BuildContext context, PermissionType type) {
    final benefits = _getBenefits(type);

    final textTheme = MTextTheme.of(context);

    return Column(
      crossAxisAlignment: .start,
      children: [
        MText('This allows you to:', style: textTheme.bodyBold),
        const SizedBox(height: 8),
        ...benefits.map(
          (benefit) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: .start,
              children: [
                const Icon(Icons.check_circle, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: MText(benefit, style: textTheme.captionMedium)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIcon(PermissionType type) {
    return switch (type) {
      PermissionType.microphone => Icons.mic,
      PermissionType.notification => Icons.notifications,
      PermissionType.background => Icons.phone_android,
    };
  }

  List<String> _getBenefits(PermissionType type) {
    return switch (type) {
      PermissionType.microphone => [
        'Broadcast your voice to listeners',
        'Host live audio sessions',
        'Engage in real-time conversations',
      ],
      PermissionType.notification => [
        'Stay updated on broadcast activity',
        'Get notified when hosts go live',
        'Receive interaction updates',
      ],
      PermissionType.background => [
        'Continue broadcasting while using other apps',
        'Keep your stream running when screen is locked',
        'Ensure uninterrupted broadcast experience',
      ],
    };
  }
}

/// Permission settings dialog
class PermissionSettingsDialog extends StatelessWidget {
  const PermissionSettingsDialog({required this.rationale, super.key});

  final PermissionRationale rationale;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return AlertDialog(
      icon: Icon(Icons.settings, size: 48, color: colors.primary),
      title: MText(rationale.title),
      content: Column(
        mainAxisSize: .min,
        children: [
          MText(
            rationale.message,
            textAlign: .center,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: colors.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MText(
                    "You'll be taken to Settings to enable this permission.",
                    color: colors.onPrimaryContainer,
                    style: textTheme.captionRegular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        MTextButton(
          label: 'Not Now',
          onPressed: () => Navigator.pop(context, false),
        ),
        MPrimaryButton.icon(
          label: 'Open Settings',
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }
}

/// Permission priming screen (shown at strategic times)
class PermissionPrimingScreen extends StatelessWidget {
  const PermissionPrimingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Header
              Icon(Icons.mic, size: 80, color: colors.primary),
              const SizedBox(height: 24),

              MText(
                'Ready to Go Live?',
                style: textTheme.heading2Bold,
                textAlign: .center,
              ),
              const SizedBox(height: 12),

              MText(
                'To start broadcasting, we need a few quick permissions',
                style: textTheme.bodyMedium,
                textAlign: .center,
              ),

              const SizedBox(height: 48),

              // Permission cards
              const _PermissionCard(
                icon: Icons.mic,
                title: 'Microphone',
                description: 'Essential for broadcasting your voice',
                required: true,
              ),
              const SizedBox(height: 16),

              if (Theme.of(context).platform == TargetPlatform.android)
                const _PermissionCard(
                  icon: Icons.phone_android,
                  title: 'Background Mode',
                  description: 'Keep broadcasting when you switch apps',
                  required: true,
                ),

              const SizedBox(height: 16),

              const _PermissionCard(
                icon: Icons.notifications,
                title: 'Notifications',
                description: 'Stay updated on broadcast activity',
                required: false,
              ),

              const Spacer(),

              // Action buttons
              MPrimaryButton(
                onPressed: () async {
                  final service = di<PermissionsService>();

                  final ctx = PermissionContext(
                    showRationale: context.showPermissionRationale,
                    showSettingsPrompt: context.showPermissionSettingsPrompt,
                  );

                  service.requestBroadcastPermissions.run(ctx);

                  // Check if we can proceed
                  if (service.canBroadcast && context.mounted) {
                    context.pop(true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                label: 'Continue',
              ),

              const SizedBox(height: 12),

              MTextButton(
                onPressed: () => context.pop(false),
                label: 'Maybe Later',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.required,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colors.outline.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colors.onPrimaryContainer),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    MText(title, style: textTheme.heading3Medium),
                    if (required) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.errorContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: MText(
                          'Required',
                          color: colors.onErrorContainer,
                          style: textTheme.captionRegular,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                MText(
                  description,
                  color: colors.onBackground.withValues(alpha: 0.7),
                  style: textTheme.captionRegular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
