import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/features/onboarding/infrastructure/onboarding_items.dart';
import 'package:meno_fe_v1/router/m_router.dart';

import '../widgets/meno_logo.dart';
import '../widgets/onboarding_body.dart';
import '../widgets/onboarding_indicator.dart';

@RoutePage()
class OnboardingPage extends HookWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(seconds: 10),
    );

    final pageController = usePageController();
    final currentIndex = useState(0);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // LayoutGrid.of(context).showRows();
        // LayoutGrid.of(context).showColumns();
      });

      //Add listener to AnimationController for know when end the count and change to the next page
      animationController.addListener(() {
        if (animationController.status == AnimationStatus.completed) {
          // animationController.reset(); //Reset the controller
          const int page = 4; //Number of pages in your PageView
          if (currentIndex.value < page) {
            currentIndex.value++;
            pageController.animateToPage(
              currentIndex.value,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInSine,
            );
          } else {
            currentIndex.value = 0;
          }
        }
      });

      return;
    });

    animationController.forward();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
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
                  onPageChanged: (value) {
                    currentIndex.value = value;
                    animationController.forward();
                  },
                  itemCount: onboardingItems.length,
                  itemBuilder: (context, index) => OnboardingBody(
                    onboard: onboardingItems[index],
                  ),
                ),
              ),
              48.verticalSpace,
              OnboardingIndicator(currentIndex: currentIndex.value),
              24.verticalSpace,
              MPrimaryButton(label: "Get started", onPressed: () {}),
              MSize.verticalSpaceLarge,
              MSecondaryButton(
                label: "Login",
                onPressed: () => context.router.navigate(LoginRoute()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
