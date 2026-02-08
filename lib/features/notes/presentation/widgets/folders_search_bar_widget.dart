import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class FolderSearchBarWidget extends StatefulWidget {
  const FolderSearchBarWidget({super.key});

  @override
  State<FolderSearchBarWidget> createState() => _FolderSearchBarWidgetState();
}

class _FolderSearchBarWidgetState extends State<FolderSearchBarWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // context.read<FoldersBloc>().add(FoldersSearchKeywordsChanged(query));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    // final showSearch = context.select<FoldersBloc, bool>(
    //       (bloc) => !(bloc.state.status == FoldersStatus.success &&
    //       bloc.state.folders.isEmpty &&
    //       (bloc.state.currentKeywords?.isEmpty ?? true)),
    // );
    //
    // final isLoading = context.select<FoldersBloc, bool>(
    //       (bloc) => bloc.state.status == FoldersStatus.loading,
    // );
    //
    // if (!showSearch && !isLoading) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(Insets.lg),
      child: SizedBox(
        height: 40,
        child: SearchBar(
          controller: _controller,
          elevation: const WidgetStatePropertyAll(0),
          onChanged: _onSearchChanged,
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
                  _controller.clear();
                  _onSearchChanged('');
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
