import 'package:flutter/material.dart';
import 'package:meno/features/discover/domain/filter.dart';
import 'package:meno_design_system/meno_design_system.dart';

class SearchFilterList extends StatelessWidget {
  const SearchFilterList({
    required this.filter,
    required this.onSelected,
    super.key,
  });

  final Filter filter;
  final ValueChanged<Filter> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    const filters = Filter.values;
    return ListView.separated(
      itemBuilder: (context, i) {
        final selected = filter == filters[i];
        return ChoiceChip(
          label: MText(
            filters[i].name,
            color: selected ? colors.onPrimary : colors.onInActiveContainer,
          ),
          selected: selected,
          labelStyle: textTheme.captionMedium,
          onSelected: (_) => onSelected(filters[i]),
        );
      },
      separatorBuilder: (context, i) => Spaces.horizontalLarge,
      itemCount: filters.length,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
    );
  }
}
