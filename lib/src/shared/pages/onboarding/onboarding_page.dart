import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/settings/settings.dart';
import 'package:meno_fe_v1/src/shared/pages/onboarding/onboarding.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(facade: di<ISettingsFacade>()),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends HookWidget {
  const OnboardingView({super.key});

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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spaces.verticalXLarge,
                const MenoLogo(),
                const SizedBox(height: 72),
                LimitedBox(
                  maxHeight: 372,
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (value) => currentIndex.value = value,
                    itemCount: items.length,
                    itemBuilder: (context, i) => OnboardingBody(items[i]),
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
                    onPressed: () => router.push(Routes.register),
                  ),
                ),
                Spaces.verticalLarge,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MSecondaryButton(
                    label: 'Login',
                    onPressed: () => router.push(Routes.loginWithLeading),
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
