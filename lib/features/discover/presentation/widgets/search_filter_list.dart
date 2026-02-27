import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/discover/applications/discover_manager.dart';
import 'package:meno/features/discover/domain/filter.dart';
import 'package:meno_design_system/meno_design_system.dart';

class SearchFilterList extends WatchingWidget {
  const SearchFilterList({super.key});

  @override
  Widget build(BuildContext context) {
    final filter = watchValue((DiscoverManager m) => m.filter);

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
          onSelected: (_) => di<DiscoverManager>().onChanged(filters[i]),
        );
      },
      separatorBuilder: (context, i) => Spaces.horizontalLarge,
      itemCount: filters.length,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
    );
  }
}
