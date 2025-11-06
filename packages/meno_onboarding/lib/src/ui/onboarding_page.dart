import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_domain/meno_domain.dart';
import 'package:meno_onboarding/src/domain/domain.dart';
import 'package:meno_onboarding/src/ui/ui.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late List<OnboardingItem> items;
  late Timer? timer;
  late PageController pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();

    items = onboardingItems;
    pageController = PageController();
    currentIndex = 0;
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
      if (currentIndex < onboardingItems.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }

      // Use pageController to animate to the next page
      await pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spaces.verticalXLarge,
                const MLogo(),
                72.verticalSpace,
                LimitedBox(
                  maxHeight: 372.h,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: items.length,
                    itemBuilder: (context, i) => OnboardingBody(items[i]),
                    onPageChanged: (i) => setState(() => currentIndex = i),
                  ),
                ),
                Spaces.verticalXXXLarge,
                OnboardingIndicator(
                  currentIndex: currentIndex,
                  itemsLength: onboardingItems.length,
                ),
                Spaces.verticalXLarge,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16).r,
                  child: MPrimaryButton(
                    label: 'Get started',
                    onPressed: () => context.push(MRoutes.registerPath),
                  ),
                ),
                Spaces.verticalLarge,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16).r,
                  child: MSecondaryButton(
                    label: 'Login',
                    onPressed: () => context.push(
                      MRoutes.login(implyLeading: true),
                    ),
                  ),
                ),
                64.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
