import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class OthersProfilePage extends StatelessWidget {
  const OthersProfilePage({required this.userId, super.key});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OthersProfileCubit(
        facade: di<IProfileFacade>(),
        userId: userId,
      )..fetch(),
      child: const OthersProfileView(),
    );
  }
}

class OthersProfileView extends StatelessWidget {
  const OthersProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final colors = MColorScheme.of(context)!;
    const shape = RoundedRectangleBorder(borderRadius: Corners.sm);

    return BlocBuilder<OthersProfileCubit, OthersProfileState>(
      builder: (context, state) => state.when(
        loading: () => const MScaffold(
          body: Center(child: MLoadingIndicator.box()),
        ),
        failure: (exception) => MScaffold(
          body: Center(
            child: Text(
              exception.maybeWhen(
                message: (message) => message,
                networkError: () => MErrorMessages.networkError,
                serverError: () => MErrorMessages.serverError,
                timeOutError: () => MErrorMessages.timeOutError,
                orElse: () => MErrorMessages.unknownError,
              ),
            ),
          ),
        ),
        success: (profile) => MScaffold(
          appBar: MAppBar.secondary(
            title: profile.fullName.getOr(),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(MIcons.dots_horizontal),
                iconSize: 24,
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Spaces.verticalLarge,
                Row(
                  children: [
                    MAvatar(radius: 40, url: profile.imageUrl),
                    const SizedBox(width: 24),
                    Expanded(child: ProfileStats(stats: profile.stats)),
                  ],
                ),
                Spaces.verticalLarge,
                Container(
                  alignment: Alignment.centerLeft,
                  child: ProfileBio(bio: profile.bio),
                ),
                Spaces.verticalLarge,
                SizedBox(
                  height: 35,
                  child: Row(
                    children: [
                      Expanded(
                        child: MSecondaryButton.icon(
                          label: 'Subscribe',
                          icon: const Icon(MIcons.users_check),
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colors.primary!),
                            textStyle: textTheme.microMedium,
                            shape: shape,
                          ),
                        ),
                      ),
                      Spaces.horizontalLarge,
                      Expanded(
                        child: MSecondaryButton.icon(
                          label: 'Share profile',
                          icon: Icon(
                            MIcons.share,
                            color: colors.onBackground,
                          ),
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colors.outlineVariant3!),
                            foregroundColor: colors.onBackground,
                            textStyle: textTheme.microMedium,
                            shape: shape,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spaces.verticalLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
