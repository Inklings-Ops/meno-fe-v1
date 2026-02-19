import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/bible/infrastructure/infrastructure.dart';
import 'package:meno/features/notes/infrastructure/infrastructure.dart';
import 'package:meno/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Database with MLogger implements Disposable {
  Database._(this._store) {
    _verseBox = _store.box<VerseDto>();
    _translationBox = _store.box<TranslationDto>();
    _noteBox = _store.box<NoteDto>();
    _noteFolderBox = _store.box<NoteFolderDto>();
    _noteCreatorBox = _store.box<NoteCreatorDto>();
  }

  final Store _store;

  // ==========================================================================
  // BIBLE
  // ==========================================================================
  late final Box<VerseDto> _verseBox;
  late final Box<TranslationDto> _translationBox;

  // ==========================================================================
  // NOTES
  // ==========================================================================
  late final Box<NoteDto> _noteBox;
  late final Box<NoteFolderDto> _noteFolderBox;
  late final Box<NoteCreatorDto> _noteCreatorBox;

  // ==========================================================================
  // FACTORY
  // ==========================================================================
  static Future<Database> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final directory = p.join(docsDir.path, 'meno');

    final store = Store.isOpen(directory)
        ? Store.attach(getObjectBoxModel(), directory)
        : await openStore(directory: directory);

    return Database._(store);
  }

  // ==========================================================================
  // BOX ACCESSORS
  // ==========================================================================
  Box<VerseDto> get verseBox => _verseBox;

  Box<TranslationDto> get translationBox => _translationBox;

  Box<NoteDto> get noteBox => _noteBox;

  Box<NoteFolderDto> get noteFolderBox => _noteFolderBox;

  Box<NoteCreatorDto> get noteCreatorBox => _noteCreatorBox;

  // ==========================================================================
  // TRANSACTION HELPERS
  // ==========================================================================
  /// Runs a synchronous write transaction.
  T runWriteTx<T>(T Function() fn) => _store.runInTransaction(TxMode.write, fn);

  /// Runs an async write transaction on ObjectBox's background thread pool.
  /// Prefer this for bulk inserts (e.g. seeding 31k verses).
  Future<R> runWriteTxAsync<R, P>(
    R Function(Store store, P parameter) callback,
    P param,
  ) => _store.runInTransactionAsync(TxMode.write, callback, param);

  @override
  FutureOr<dynamic> onDispose() {
    log.i('Database: Disposing...');

    _store.close();
  }
}
