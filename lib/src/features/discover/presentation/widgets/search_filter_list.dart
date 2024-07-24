import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';

class SearchFilterList extends StatelessWidget {
  const SearchFilterList({
    super.key,
    required this.filter,
    required this.onSelected,
  });
  final Filter filter;
  final ValueChanged<Filter> onSelected;
  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
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
          labelStyle: $styles.text.captionMedium,
          onSelected: (_) => onSelected(filters[i]),
        );
      },
      separatorBuilder: (context, i) => $styles.spaces.horizontalLarge,
      itemCount: filters.length,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: $styles.insets.large),
    );
  }
}
