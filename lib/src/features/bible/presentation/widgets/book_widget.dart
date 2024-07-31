import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/bible/application/scripture_picker/scripture_picker_cubit.dart';

import 'chapters_grid.dart';

class BookWidget extends HookWidget {
  final String bookName;
  final VoidCallback? onTap;

  const BookWidget({
    super.key,
    required this.bookName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    const borderRadius = Corners.small;
    final bloc = context.watch<ScripturePickerCubit>();
    final isSelected = useState<bool>(bloc.state.book == bookName);

    useEffect(() {
      isSelected.value = bloc.state.book == bookName;
      return null;
    }, [bloc.state.book]);

    return Column(
      children: [
        InkWell(
          borderRadius: borderRadius,
          onTap: () {
            if (!isSelected.value) {
              bloc.bookChanged(bookName);
              isSelected.value = true;
            } else {
              isSelected.value = false;
            }
            onTap?.call();
          },
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: colors.outlineVariant2,
              borderRadius: borderRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MText(bookName),
                const Icon(MIcons.plus, size: 20),
              ],
            ),
          ),
        ),
        Visibility(
          visible: isSelected.value,
          child: ChaptersGrid(chapterLength: bloc.state.chapterLength),
        ),
      ],
    );
  }
}
