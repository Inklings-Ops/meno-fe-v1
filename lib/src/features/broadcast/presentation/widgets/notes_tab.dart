import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NotesTab extends HookWidget {
  const NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MCore.large).r,
      child: NoteBodyWidget(selectedIndex: selectedIndex),
    );
  }
}
