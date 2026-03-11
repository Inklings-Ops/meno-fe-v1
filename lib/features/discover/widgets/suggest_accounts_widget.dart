import 'package:flutter/material.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/profile/model/_model.dart';
import 'package:meno/features/profile/widgets/profile_card.dart';

final _profiles = <Profile>[
  Profile(
    id: Id.fromString('178d88c6-1674-4135-a68b-88877b902ab2'),
    bio: MultiLineString("The Lord's favoured."),
    fullName: SingleLineString('Christie David Michael'),
    image: ImageInput.fromUrl(
      'https://res.cloudinary.com/gson007/image/upload/v1668024849/pjxxonawlab2bvn8la9o.jpg',
    ),
  ),
  Profile(
    id: Id.fromString('6fe8dbf2-e0ec-4d8c-bb13-fb9583cda788'),
    bio: MultiLineString(
      '''
David Michael: Always wanting to know more of God. Super charged with the Spirit.\nHallelujah!''',
    ),
    fullName: SingleLineString('David Michael'),
    image: ImageInput.fromUrl(
      'https://res.cloudinary.com/gson007/image/upload/v1741767889/erixhls5hpuuibb6ou9h.jpg',
    ),
  ),
  Profile(
    id: Id.fromString('3e43bf4d-7ab1-4d30-92d7-02fedf2d5ed1'),
    fullName: SingleLineString('David Michael II'),
    image: ImageInput.fromUrl(
      'https://res.cloudinary.com/gson007/image/upload/v1698913558/nephz6baho5wgkg8wrz0.jpg',
    ),
  ),
  Profile(
    id: Id.fromString('6a86d27a-f923-4e52-9b01-b8667591375a'),
    fullName: SingleLineString('STU David Michael'),
    image: ImageInput.fromUrl(
      'https://res.cloudinary.com/gson007/image/upload/v1668023831/l0kvyd27pddlspuwa2xp.jpg',
    ),
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
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final profile = profiles[index];
        if (profile == null) return const SizedBox.shrink();

        return ProfileCard(
          profile: profile,
          onTap: () => context.push(R.profile(profile.id.getOrCrash())),
        );
      },
    );
  }
}
