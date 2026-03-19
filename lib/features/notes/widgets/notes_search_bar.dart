import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/manager/_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NotesSearchBar extends WatchingWidget {
  const NotesSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<NotesManager>();
    final controller = createOnce(TextEditingController.new);
    callOnce((_) => controller.text = manager.searchQuery.value);
    watch(controller);
    final searchQuery = watchValue((NotesManager m) => m.searchQuery);
    if (controller.text != searchQuery) controller.text = searchQuery;
    final textTheme = MTextTheme.of(context);
    return Container(
      height: 40,
      padding: const .symmetric(horizontal: 16),
      child: SearchBar(
        elevation: const WidgetStatePropertyAll(0),
        controller: controller,
        onChanged: manager.performSearch.run,
        hintText: 'Search for note',
        hintStyle: WidgetStatePropertyAll(textTheme.captionRegular),
        padding: const WidgetStatePropertyAll(
          .symmetric(horizontal: Insets.md),
        ),
        leading: const Icon(MIcons.search, size: Insets.lg),
        trailing: [
          if (controller.text.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.clear, size: Insets.lg),
              onPressed: () {
                controller.clear();
                manager.clearSearch();
              },
            ),
          ],
        ],
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: BorderSide(color: Color(0xFFC2C7D0)),
            borderRadius: Corners.sm,
          ),
        ),
      ),
    );
  }
}
