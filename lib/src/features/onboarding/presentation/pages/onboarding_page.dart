import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../router/router.dart';
import '../../infrastructure/onboarding_items.dart';
import '../widgets/meno_logo.dart';
import '../widgets/onboarding_body.dart';
import '../widgets/onboarding_indicator.dart';

class OnboardingPage extends HookWidget {
  final ValueChanged<bool>? onBoarded;
  const OnboardingPage({super.key, this.onBoarded});

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            24.verticalSpace,
            const MenoLogo(),
            const SizedBox(height: 72),
            LimitedBox(
              maxHeight: 372,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) => currentIndex.value = value,
                itemCount: onboardingItems.length,
                itemBuilder: (context, i) => OnboardingBody(onboardingItems[i]),
              ),
            ),
            48.verticalSpace,
            OnboardingIndicator(currentIndex: currentIndex.value),
            24.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MPrimaryButton(
                label: "Get started",
                onPressed: () => context.push(Routes.register),
              ),
            ),
            MSize.verticalSpaceLarge,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MSecondaryButton(
                label: "Login",
                onPressed: () => context.pushNamed(
                  Routes.login,
                  queryParameters: {"implyLeading": "true"},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
