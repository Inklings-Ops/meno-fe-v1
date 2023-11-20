import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

enum ReactionType { clap, flame, like, raise, snap }

class Reaction {
  final ReactionType reactionType;
  final Widget icon;

  const Reaction(this.reactionType, this.icon);
}

final List<Reaction> reactions = <Reaction>[
  Reaction(
    ReactionType.clap,
    Assets.images.clappingHands.image(height: 20.r, width: 20.r),
  ),
  Reaction(
    ReactionType.flame,
    Assets.images.flame.image(height: 20.r, width: 20.r),
  ),
  Reaction(
    ReactionType.like,
    Assets.images.redHeart.image(height: 20.r, width: 20.r),
  ),
  Reaction(
    ReactionType.raise,
    Assets.images.raisingHands.image(height: 20.r, width: 20.r),
  ),
  Reaction(
    ReactionType.snap,
    Assets.images.fingerSnap.image(height: 20.r, width: 20.r),
  ),
];
