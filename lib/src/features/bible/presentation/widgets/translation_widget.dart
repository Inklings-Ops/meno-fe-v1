import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/bible/application/translations/translations_cubit.dart';
import 'package:meno_fe_v1/src/features/bible/domain/domain.dart';

class TranslationWidget extends StatelessWidget {
  const TranslationWidget({
    super.key,
    required this.translation,
    this.onTap,
  });

  final Translation translation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    final bloc = context.watch<TranslationsCubit>();
    final isSelected = bloc.state.selectedTranslation == translation;
    final abbreviation = translation.abbreviation.toUpperCase();
    final name = translation.name;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24).r,
      child: Container(
        height: 66.h,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12).r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24).r,
          border: isSelected ? Border.all(color: colors.primary!) : null,
          color: isSelected ? colors.primaryContainer : colors.outlineVariant2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MText(abbreviation, style: MTextStyle.bodyMedium),
                MText(name, style: MTextStyle.microRegular),
              ],
            )
          ],
        ),
      ),
    );
  }
}
