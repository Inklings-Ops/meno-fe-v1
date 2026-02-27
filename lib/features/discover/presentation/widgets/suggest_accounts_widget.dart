import 'package:flutter/material.dart';
import 'package:meno/features/profile/domain/profile.dart';
import 'package:meno/features/profile/presentation/widgets/profile_card.dart';
import 'package:meno/shared/domain/domain.dart';

final _profiles = <Profile>[
  Profile(
    id: Id.fromString('178d88c6-1674-4135-a68b-88877b902ab2'),
    bio: MultiLineString("The Lord's favoured."),
    fullName: SingleLineString('Christie David Michael'),
    imageUrl: '''
https://res.cloudinary.com/gson007/image/upload/v1668024849/pjxxonawlab2bvn8la9o.jpg''',
  ),
  Profile(
    id: Id.fromString('6fe8dbf2-e0ec-4d8c-bb13-fb9583cda788'),
    bio: MultiLineString(
      '''
David Michael: Always wanting to know more of God. Super charged with the Spirit.\nHallelujah!''',
    ),
    fullName: SingleLineString('David Michael'),
    imageUrl: '''
https://res.cloudinary.com/gson007/image/upload/v1741767889/erixhls5hpuuibb6ou9h.jpg''',
  ),
  Profile(
    id: Id.fromString('3e43bf4d-7ab1-4d30-92d7-02fedf2d5ed1'),
    fullName: SingleLineString('David Michael II'),
    imageUrl: '''
https://res.cloudinary.com/gson007/image/upload/v1698913558/nephz6baho5wgkg8wrz0.jpg''',
  ),
  Profile(
    id: Id.fromString('6a86d27a-f923-4e52-9b01-b8667591375a'),
    fullName: SingleLineString('STU David Michael'),
    imageUrl: '''
https://res.cloudinary.com/gson007/image/upload/v1668023831/l0kvyd27pddlspuwa2xp.jpg''',
  ),
];

class SuggestAccountsWidget extends StatelessWidget {
  const SuggestAccountsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _List(profiles: _profiles);
  }
}

class _List extends StatelessWidget {
  const _List({required this.profiles});

  final List<Profile?> profiles;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 159.50 / 192,
      ),
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      itemBuilder: (context, i) => ProfileCard(profile: profiles[i]!),
      itemCount: profiles.length,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
