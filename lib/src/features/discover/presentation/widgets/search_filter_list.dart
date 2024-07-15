import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
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
    const filters = Filter.values;
    return ListView.separated(
      itemBuilder: (context, i) => ChoiceChip(
        label: MText(filters[i].name),
        selected: filter == filters[i],
        onSelected: (_) => onSelected(filters[i]),
      ),
      separatorBuilder: (context, i) => MCore.large.horizontalSpace,
      itemCount: filters.length,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: MCore.large).r,
    );
  }
}
