import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/shared/shared.dart';

class ProfileBroadcastsManager with MLogger implements Disposable {
  ProfileBroadcastsManager({
    required IBroadcastFeedSource broadcastFeedSource,
    required Id userId,
  }) : _broadcastFeedSource = broadcastFeedSource,
       _userId = userId;

  final IBroadcastFeedSource _broadcastFeedSource;
  final Id _userId;

  late final pagedList = ValueNotifier(const PagedList<Broadcast?>.empty());

  late final error = ValueNotifier<MenoException?>(null);

  late final _query = ValueNotifier(
    BroadcastQuery.byCreator(creatorId: _userId),
  );

  late final fetch = Command.createAsyncNoParamNoResult(() async {
    final result = await _broadcastFeedSource.getBroadcasts(_query.value);
    result.fold(
      (failure) => error.value = failure,
      (page) => pagedList.value = page,
    );
  }, errorFilterFn: menoExceptionFilter);

  late final fetchMore = Command.createAsyncNoParamNoResult(() async {
    final nextQuery = _query.value.nextPage();
    final result = await _broadcastFeedSource.getBroadcasts(nextQuery);
    result.fold((failure) => error.value = failure, pagedList.value.merge);
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() async {
    pagedList.dispose();

    fetch.dispose();
    fetchMore.dispose();
  }
}
