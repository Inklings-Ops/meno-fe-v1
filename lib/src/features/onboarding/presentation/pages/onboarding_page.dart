import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../router/router.dart';
import '../../../auth/application/application.dart';
import '../../infrastructure/onboarding_items.dart';
import '../widgets/meno_logo.dart';
import '../widgets/onboarding_body.dart';
import '../widgets/onboarding_indicator.dart';

class OnboardingPage extends HookConsumerWidget {
  final ValueChanged<bool>? onBoarded;
  const OnboardingPage({super.key, this.onBoarded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late Timer? timer;
    final pageController = usePageController();
    final currentIndex = useState(0);

    useEffect(() {
      timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
        if (currentIndex.value < onboardingItems.length - 1) {
          currentIndex.value++;
        } else {
          currentIndex.value = 0;
        }

        pageController.animateToPage(
          currentIndex.value,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeIn,
        );
      });
      return () {
        timer?.cancel();
      };
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              24.verticalSpace,
              const MenoLogo(),
              72.verticalSpace,
              LimitedBox(
                maxHeight: 372.h,
                maxWidth: double.infinity,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (value) => currentIndex.value = value,
                  itemCount: onboardingItems.length,
                  itemBuilder: (context, i) => OnboardingBody(
                    onboardingItems[i],
                  ),
                ),
              ),
              48.verticalSpace,
              OnboardingIndicator(currentIndex: currentIndex.value),
              24.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                child: MPrimaryButton(
                  label: "Get started",
                  onPressed: () {
                    context.push(Routes.registerWithLeading);
                    ref.read(authProvider.notifier).completeOnboarding();
                  },
                ),
              ),
              MCore.large.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                child: MSecondaryButton(
                  label: "Login",
                  onPressed: () {
                    context.push(Routes.loginWithLeading);
                    ref.read(authProvider.notifier).completeOnboarding();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
