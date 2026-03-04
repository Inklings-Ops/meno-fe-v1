import 'package:flutter/cupertino.dart';

extension MAsyncSnapshotX on AsyncSnapshot {
  bool get isLoading => connectionState == ConnectionState.waiting;
}
