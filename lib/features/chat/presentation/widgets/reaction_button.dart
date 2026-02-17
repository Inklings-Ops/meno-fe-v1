import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:meno/features/chat/presentation/widgets/reactions.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MReactionButton extends StatelessWidget {
  const MReactionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    return Container(
      height: 56,
      padding: const EdgeInsets.all(Insets.sm),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: Corners.circle,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, i) => Spaces.horizontalSmall,
        scrollDirection: Axis.horizontal,
        itemCount: reactions.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {},
            child: AnimationConfiguration.staggeredList(
              position: i,
              duration: const Duration(milliseconds: 260),
              child: SlideAnimation(
                verticalOffset: 15 + i * 15,
                child: FadeInAnimation(
                  child: MIconButton(
                    size: 40,
                    iconSize: 20,
                    icon: reactions[i].icon,
                    isFilled: true,
                    fillColor: colors.outlineVariant2,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
