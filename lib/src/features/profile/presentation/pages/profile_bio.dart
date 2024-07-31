import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:readmore/readmore.dart';

class ProfileBio extends StatelessWidget {
  const ProfileBio({required this.bio, super.key});
  final Bio? bio;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final style = textTheme.captionMedium?.copyWith(
      color: MColorScheme.of(context)!.onBackgroundVariant,
    );

    return ReadMoreText(
      bio?.getOr() ?? 'No bio',
      style: textTheme.captionRegular,
      trimLines: 3,
      trimMode: TrimMode.Line,
      trimExpandedText: '\nless',
      trimCollapsedText: '\nmore',
      moreStyle: style,
      lessStyle: style,
    );
  }
}
