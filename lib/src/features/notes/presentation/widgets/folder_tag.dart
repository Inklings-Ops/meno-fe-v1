import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class FolderTag extends StatelessWidget {
  const FolderTag({required this.folder, super.key});
  final Folder folder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MTag(
          title: folder.title.getOrCrash(),
          style: MTextTheme.of(context).microMedium,
        ),
      ],
    );
  }
}
