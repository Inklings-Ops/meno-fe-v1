import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class FolderSearchBox extends StatefulWidget {
  const FolderSearchBox({super.key});

  @override
  State<FolderSearchBox> createState() => _FolderSearchBoxState();
}

class _FolderSearchBoxState extends State<FolderSearchBox> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<FoldersBloc>().add(FolderSearchChanged(query));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;

    final showSearch = context.select<FoldersBloc, bool>(
      (bloc) => !(bloc.state.status == FoldersStatus.success &&
          bloc.state.folders.isEmpty &&
          (bloc.state.currentKeywords?.isEmpty ?? true)),
    );

    final isLoading = context.select<FoldersBloc, bool>(
      (bloc) => bloc.state.status == FoldersStatus.loading,
    );

    if (!showSearch && !isLoading) return const SizedBox.shrink();

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
