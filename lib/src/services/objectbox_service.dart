import 'package:meno_fe_v1/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBoxService {
  late final Store store;

  ObjectBoxService._create(this.store) {
    // Add any additional setup code, e.g. build queries.

    // store.box<VerseDto>().removeAll();
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBoxService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, 'meno'));
    return ObjectBoxService._create(store);
  }
}
