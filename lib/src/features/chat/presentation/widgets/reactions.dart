import 'package:meno_fe_v1/meno.dart';

enum ReactionType { clap, flame, like, raise, snap }

class Reaction {

  const Reaction(this.reactionType, this.icon);
  final ReactionType reactionType;
  final Widget icon;
}

const dimension = 20.0;

final List<Reaction> reactions = <Reaction>[
  Reaction(
    ReactionType.clap,
    Assets.images.clappingHands.image(height: dimension, width: dimension),
  ),
  Reaction(
    ReactionType.flame,
    Assets.images.flame.image(height: dimension, width: dimension),
  ),
  Reaction(
    ReactionType.like,
    Assets.images.redHeart.image(height: dimension, width: dimension),
  ),
  Reaction(
    ReactionType.raise,
    Assets.images.raisingHands.image(height: dimension, width: dimension),
  ),
  Reaction(
    ReactionType.snap,
    Assets.images.fingerSnap.image(height: dimension, width: dimension),
  ),
];
