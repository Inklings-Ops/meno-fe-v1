import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NotesTab extends HookWidget {
  const NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      child: NoteBodyWidget(selectedIndex: selectedIndex),
    );
  }
}
