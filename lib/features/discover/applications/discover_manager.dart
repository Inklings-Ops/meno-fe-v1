import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/discover/domain/filter.dart' show Filter;

class DiscoverManager implements Disposable {
  final filter = ValueNotifier<Filter>(.all);

  void onChanged(Filter value) => filter.value = value;

  void goToNowLive() => filter.value = .nowLive;

  void goToRecentlyLive() => filter.value = .recentlyLive;

  @override
  FutureOr<dynamic> onDispose() {
    filter.dispose();
  }
}
