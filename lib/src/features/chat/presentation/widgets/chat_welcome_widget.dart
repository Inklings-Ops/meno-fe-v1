import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/chat/application/application.dart';

class ChatWelcomeWidget extends StatelessWidget {
  const ChatWelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return Container(
      height: 88,
      padding: const EdgeInsets.all(Insets.lg),
      margin: const EdgeInsets.symmetric(
        horizontal: Insets.lg,
        vertical: Insets.sm,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(Insets.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Insets.xxl,
            height: Insets.xxl,
            padding: const EdgeInsets.symmetric(vertical: 10),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colors.onPrimaryContainer,
              borderRadius: BorderRadius.circular(Insets.md),
            ),
            child: Assets.images.logoLight.svg(),
          ),
          Spaces.horizontalLarge,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Insets.xxl,
                  child: MText(
                    '''Welcome to the live chat! We encourage you to be as interactive as you can.''',
                    style: textTheme.microRegular,
                  ),
                ),
                Spaces.verticalSmall,
                SizedBox(
                  height: Insets.lg,
                  child: MTextButton(
                    label: 'OK, THANK YOU',
                    onPressed: () {
                      context.read<ChatBloc>().add(const HideChatWelcomeNote());
                    },
                    style: TextButton.styleFrom(
                      textStyle: textTheme.microMedium,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
