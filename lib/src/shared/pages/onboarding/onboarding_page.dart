import 'dart:async';

import 'package:meno_fe_v1/meno.dart';

import 'onboarding.dart';

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
              24.vSpace,
              const MenoLogo(),
              72.vSpace,
              LimitedBox(
                maxHeight: 372.toScale,
                maxWidth: double.infinity,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (value) => currentIndex.value = value,
                  itemCount: items.length,
                  itemBuilder: (context, i) => OnboardingBody(items[i]),
                ),
              ),
              48.vSpace,
              OnboardingIndicator(
                currentIndex: currentIndex.value,
                itemsLength: onboardingItems.length,
              ),
              24.vSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0).radius,
                child: MPrimaryButton(
                  label: 'Get started',
                  onPressed: () => context.push(Routes.registerWithLeading),
                ),
              ),
              $styles.spaces.verticalLarge,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0).radius,
                child: MSecondaryButton(
                  label: 'Login',
                  onPressed: () => context.push(Routes.loginWithLeading),
                ),
              ),
              64.vSpace,
            ],
          ),
        ),
      ),
    );
  }
}
