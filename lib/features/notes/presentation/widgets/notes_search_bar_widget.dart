import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NoteSearchBarWidget extends StatefulWidget {
  const NoteSearchBarWidget({super.key});

  @override
  State<NoteSearchBarWidget> createState() => _NoteSearchBarWidgetState();
}

class _NoteSearchBarWidgetState extends State<NoteSearchBarWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // context.read<NotesBloc>().add(NotesSearchKeywordChanged(query));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    // final showSearch = context.select<NotesBloc, bool>(
    //   (bloc) =>
    //       bloc.state.status != NotesStatus.initial &&
    //       !(bloc.state.status == NotesStatus.loadSuccess &&
    //           bloc.state.notes.isEmpty &&
    //           (bloc.state.currentKeywords?.isEmpty ?? true)),
    // );

    // final isLoading = context.select<NotesBloc, bool>(
    //   (bloc) => bloc.state.status == NotesStatus.loading,
    // );

    // if (!showSearch && !isLoading) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(Insets.lg),
      child: SizedBox(
        height: 40,
        child: SearchBar(
          controller: _controller,
          elevation: const WidgetStatePropertyAll(0),
          onChanged: _onSearchChanged,
          hintText: 'Search for note',
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
