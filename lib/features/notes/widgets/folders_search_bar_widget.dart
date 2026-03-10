import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/manager/folders_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';

const _debounceTime = Duration(milliseconds: 400);

class FolderSearchBarWidget extends WatchingWidget {
  const FolderSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    final manager = di<FoldersManager>();
    final keywords = createOnce(() => ValueNotifier<String>(''));
    final debouncedQuery = createOnce(() => keywords.debounce(_debounceTime));

    registerHandler(
      target: debouncedQuery,
      handler: (context, String value, _) => manager.performSearch.run(value),
    );

    watchValue((FoldersManager m) => m.searchQuery);

    return Padding(
      padding: const EdgeInsets.all(Insets.lg),
      child: SizedBox(
        height: 40,
        child: SearchBar(
          elevation: const WidgetStatePropertyAll(0),
          onChanged: (input) => keywords.value = input,
          hintText: 'Search for folder',
          hintStyle: WidgetStatePropertyAll(textTheme.captionRegular),
          padding: const WidgetStatePropertyAll(
            .symmetric(horizontal: Insets.md),
          ),
          leading: const Icon(MIcons.search, size: Insets.lg),
          trailing: [
            if (keywords.value.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, size: Insets.lg),
                onPressed: () {
                  keywords.value = '';
                  manager.searchQuery.value = '';
                  manager.performSearch.run('');
                },
              ),
          ],
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              side: BorderSide(color: Color(0xFFC2C7D0)),
              borderRadius: Corners.sm,
            ),
          ),
        ),
      ),
    );
  }
}
