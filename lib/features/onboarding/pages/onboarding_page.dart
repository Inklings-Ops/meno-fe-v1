import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/onboarding/onboarding.dart';
import 'package:meno_design_system/meno_design_system.dart';

class OnboardingPage extends WatchingWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = createOnce(PageController.new);
    final currentIndex = createOnce(() => ValueNotifier(0));

    callOnce((_) {
      final timer = Timer.periodic(const Duration(seconds: 5), (_) {
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

      onDispose(timer.cancel);
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spaces.verticalXLarge,
                if (Theme.of(context).brightness == .light)
                  Assets.images.menoPurple.image(height: 32)
                else
                  Assets.images.menoWhite.image(height: 32),
                const SizedBox(height: 72),
                LimitedBox(
                  maxHeight: 372,
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (value) => currentIndex.value = value,
                    itemCount: onboardingItems.length,
                    itemBuilder: (_, i) => OnboardingBody(onboardingItems[i]),
                  ),
                ),
                Spaces.verticalXXXLarge,
                OnboardingIndicator(
                  currentIndex: currentIndex.value,
                  itemsLength: onboardingItems.length,
                ),
                Spaces.verticalXLarge,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MPrimaryButton(
                    label: 'Get started',
                    onPressed: () => context.push(R.register),
                  ),
                ),
                Spaces.verticalLarge,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MSecondaryButton(
                    label: 'Login',
                    onPressed: () => context.push(R.loginWithLeading),
                  ),
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
