import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:meno_design_system/meno_design_system.dart';

enum ReactionType { clap, flame, like, raise, snap }

class MReaction {
  const MReaction(this.reactionType, this.icon);

  final ReactionType reactionType;
  final Widget icon;
}

final List<MReaction> reactions = <MReaction>[
  MReaction(
    ReactionType.clap,
    Assets.images.clappingHands.image(height: 20, width: 20),
  ),
  MReaction(
    ReactionType.flame,
    Assets.images.flame.image(height: 20, width: 20),
  ),
  MReaction(
    ReactionType.like,
    Assets.images.redHeart.image(height: 20, width: 20),
  ),
  MReaction(
    ReactionType.raise,
    Assets.images.raisingHands.image(height: 20, width: 20),
  ),
  MReaction(
    ReactionType.snap,
    Assets.images.fingerSnap.image(height: 20, width: 20),
  ),
];

final List<Reaction<ReactionType>> mainReactions = <Reaction<ReactionType>>[
  Reaction(
    value: ReactionType.clap,
    icon: Assets.images.clappingHands.image(height: 20, width: 20),
  ),
  Reaction(
    value: ReactionType.flame,
    icon: Assets.images.flame.image(height: 20, width: 20),
  ),
  Reaction(
    value: ReactionType.like,
    icon: Assets.images.redHeart.image(height: 20, width: 20),
  ),
  Reaction(
    value: ReactionType.raise,
    icon: Assets.images.raisingHands.image(height: 20, width: 20),
  ),
  Reaction(
    value: ReactionType.snap,
    icon: Assets.images.fingerSnap.image(height: 20, width: 20),
  ),
];
