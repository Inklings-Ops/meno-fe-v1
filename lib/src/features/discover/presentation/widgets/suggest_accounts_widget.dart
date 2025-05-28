// ignore_for_file: avoid_redundant_argument_values

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

final _profiles = <Profile>[
  Profile(
    id: ID.fromString('178d88c6-1674-4135-a68b-88877b902ab2'),
    bio: MultiLineString("The Lord's favoured."),
    fullName: SingleLineString('Christie David Michael'),
    imageUrl: '''
https://res.cloudinary.com/gson007/image/upload/v1668024849/pjxxonawlab2bvn8la9o.jpg''',
  ),
  Profile(
    id: ID.fromString('6fe8dbf2-e0ec-4d8c-bb13-fb9583cda788'),
    bio: MultiLineString('''
David Michael: Always wanting to know more of God. Super charged with the Spirit.\nHallelujah!'''),
    fullName: SingleLineString('David Michael'),
    imageUrl: '''
https://res.cloudinary.com/gson007/image/upload/v1741767889/erixhls5hpuuibb6ou9h.jpg''',
  ),
  Profile(
    id: ID.fromString('3e43bf4d-7ab1-4d30-92d7-02fedf2d5ed1'),
    fullName: SingleLineString('David Michael II'),
    imageUrl: '''
https://res.cloudinary.com/gson007/image/upload/v1698913558/nephz6baho5wgkg8wrz0.jpg''',
  ),
  Profile(
    id: ID.fromString('6a86d27a-f923-4e52-9b01-b8667591375a'),
    fullName: SingleLineString('STU David Michael'),
    imageUrl: '''
https://res.cloudinary.com/gson007/image/upload/v1668023831/l0kvyd27pddlspuwa2xp.jpg''',
  ),
];

class SuggestAccountsWidget extends StatelessWidget {
  const SuggestAccountsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _List(profiles: _profiles, loading: false);
  }
}

class _List extends StatelessWidget {
  const _List({required this.profiles, this.loading = false});
  final List<Profile?> profiles;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: loading,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 159.50 / 192,
        ),
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
        itemBuilder: (context, i) {
          final profile = profiles[i]!;
          final colors = MColorScheme.of(context);
          final textTheme = MTextTheme.of(context);
          return Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(Insets.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MAvatar(
                    radius: Insets.xxl,
                    url: profile.imageUrl,
                    hasBorder: false,
                  ),
                  const Spacer(),
                  SizedBox(
                    height: Insets.xl,
                    child: MText(
                      profile.fullName.getOrCrash(),
                      style: MTextTheme.of(context).captionMedium,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spaces.verticalMicro,
                  SizedBox(
                    height: 18,
                    child: MText(
                      '6, 850 Subscribers',
                      style: textTheme.captionRegular,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: colors.onBackground.withValues(alpha: 0.6),
                    ),
                  ),
                  const Spacer(),
                  Skeleton.unite(
                    child: MSecondaryButton(
                      label: 'Subscribe',
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        textStyle: textTheme.microMedium,
                        fixedSize: const Size(double.infinity, Insets.xxl),
                        shape: const RoundedRectangleBorder(
                          borderRadius: Corners.sm,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: profiles.length,
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
