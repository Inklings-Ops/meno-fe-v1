enum Filter { all, nowLive, recentlyLive }

extension FilterX on Filter {
  String get name {
    return switch (this) {
      Filter.all => 'All',
      Filter.nowLive => 'Now Live',
      Filter.recentlyLive => 'Recently Live',
    };
  }
}
