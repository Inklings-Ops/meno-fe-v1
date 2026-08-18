import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/broadcast/broadcast.dart';

final class FavouritesManager implements Disposable {
  FavouritesManager({
    required BroadcastLocalService local,
    required Id currentUserId,
  }) : _local = local,
       _currentUserId = currentUserId;

  final BroadcastLocalService _local;
  final Id _currentUserId;

  final favourites = ListNotifier<FavouriteBroadcast?>(data: []);

  StreamSubscription<List<FavouriteBroadcast>>? _subscription;

  late final fetch = Command.createSyncNoParamNoResult(() {
    _subscription?.cancel();
    _subscription = null;

    _subscription = _local.watchFavourites(_currentUserId).listen((incoming) {
      favourites.startTransAction();
      favourites.clear();
      favourites.addAll(incoming);
      favourites.endTransAction();
    });
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() {
    _subscription?.cancel();
    _subscription = null;

    favourites.dispose();

    fetch.dispose();
  }
}
