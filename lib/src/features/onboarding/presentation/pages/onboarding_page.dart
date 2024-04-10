import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../router/router.dart';
import '../../infrastructure/onboarding_items.dart';
import '../widgets/meno_logo.dart';
import '../widgets/onboarding_body.dart';
import '../widgets/onboarding_indicator.dart';

class OnboardingPage extends HookWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Timer and state management using hooks
    late Timer? timer;
    final pageController = usePageController();
    final currentIndex = useState(0);
    final items = onboardingItems;

    useEffect(() {
      // Timer to auto-advance through onboarding pages
      timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
        if (currentIndex.value < onboardingItems.length - 1) {
          currentIndex.value++;
        } else {
          currentIndex.value = 0;
        }

        // Use pageController to animate to the next page
        pageController.animateToPage(
          currentIndex.value,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeIn,
        );
      });

      // Cleanup the timer when the widget is disposed
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
                  itemCount: items.length,
                  itemBuilder: (context, i) => OnboardingBody(items[i]),
                ),
              ),
              48.verticalSpace,
              OnboardingIndicator(currentIndex: currentIndex.value),
              24.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                child: MPrimaryButton(
                  label: 'Get started',
                  onPressed: () => context.push(Routes.registerWithLeading),
                ),
              ),
              MCore.large.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                child: MSecondaryButton(
                  label: 'Login',
                  onPressed: () => context.push(Routes.loginWithLeading),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
