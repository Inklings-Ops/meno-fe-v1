import 'package:meno/_core/value_objects/id.dart';
import 'package:meno/features/notes/model/_model.dart';
import 'package:meno/features/notes/model/proxies/note_proxy.dart';

class NoteDataRepository {
  final _proxies = <Id, NoteProxy>{};

  /// Returns the existing proxy updated with [note], or creates a new one.
  NoteProxy acquire(Note note, {required String currentUserId}) {
    final id = note.id;
    if (_proxies.containsKey(id)) {
      // Update in-place — this calls notifyListeners() on the shared proxy.
      _proxies[id]!.note = note;
    } else {
      _proxies[id] = NoteProxy(note, currentUserId: currentUserId);
    }
    _proxies[id]!.referenceCount++;
    return _proxies[id]!;
  }

  /// Decrements the reference count. Disposes and removes when it reaches 0.
  void release(NoteProxy proxy) {
    proxy.referenceCount--;
    if (proxy.referenceCount <= 0) {
      _proxies.remove(proxy.id);
      proxy.dispose();
    }
  }

  void dispose() {
    for (final proxy in _proxies.values) {
      proxy.dispose();
    }
    _proxies.clear();
  }
}
