import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/exceptions/meno_exception_filter.dart';
import 'package:meno/_core/value_objects/id.dart';
import 'package:meno/features/broadcast/broadcast.dart';

class BroadcastProxy extends ChangeNotifier {
  BroadcastProxy(this._broadcast, this._ownerId) {
    _isFavouritedOverride = _storage.isFavourited(
      broadcastId: broadcast.id,
      ownerId: _ownerId,
    );
  }

  final Id _ownerId;
  Broadcast _broadcast;

  BroadcastLocalService get _storage => di<BroadcastLocalService>();

  Broadcast get broadcast => _broadcast;

  bool? _isFavouritedOverride;

  bool get isFavourited => _isFavouritedOverride ?? false;

  String get title => _broadcast.title.getOrCrash();

  String get description => _broadcast.description.getOrElse((_) => '');

  String get creatorName => _broadcast.hostName.getOrCrash();

  String? get imageUrl => _broadcast.imageUrl;

  set broadcast(Broadcast value) {
    _isFavouritedOverride = false;
    _broadcast = value;
    notifyListeners();
  }

  late final toggleIsFavourite = Command.createUndoableNoParamNoResult<bool?>(
    (stack) async {
      stack.push(_isFavouritedOverride);
      _isFavouritedOverride = !isFavourited;
      notifyListeners();

      _storage.toggleIsFavourite(broadcast: broadcast, ownerId: _ownerId);
    },
    undo: (undoStack, reason) {
      _isFavouritedOverride = undoStack.pop();
      notifyListeners();
    },
    errorFilterFn: menoExceptionFilter,
  );

  @override
  void dispose() {
    toggleIsFavourite.dispose();
    super.dispose();
  }
}
