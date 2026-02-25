import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno_design_system/meno_design_system.dart';

class FolderSearchBarWidget extends WatchingStatefulWidget {
  const FolderSearchBarWidget({super.key});

  @override
  State<FolderSearchBarWidget> createState() => _FolderSearchBarWidgetState();
}

class _FolderSearchBarWidgetState extends State<FolderSearchBarWidget> {
  final _manager = di<FoldersManager>();

  late TextEditingController _controller;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _manager.searchQuery.value);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _manager.performSearch.run(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    watchValue((FoldersManager m) => m.searchQuery);

    return Padding(
      padding: const EdgeInsets.all(Insets.lg),
      child: SizedBox(
        height: 40,
        child: SearchBar(
          elevation: const WidgetStatePropertyAll(0),
          controller: _controller,
          onChanged: _onChanged,
          hintText: 'Search for folder',
          hintStyle: WidgetStatePropertyAll(textTheme.captionRegular),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: Insets.md),
          ),
          leading: const Icon(MIcons.search, size: Insets.lg),
          trailing: [
            if (_controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, size: Insets.lg),
                onPressed: () {
                  _debounce?.cancel();
                  _controller.clear();
                  _manager.searchQuery.value = '';
                  _manager.performSearch.run('');
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
