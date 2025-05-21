// Needs to correspond with backend
// ignore_for_file: constant_identifier_names

enum OrderBy { DESC, ASC }

extension OrderByX on OrderBy {
  String get name {
    switch (this) {
      case OrderBy.DESC:
        return 'DESC';
      case OrderBy.ASC:
        return 'ASC';
    }
  }

  String get lowercaseName {
    switch (this) {
      case OrderBy.DESC:
        return 'desc';
      case OrderBy.ASC:
        return 'asc';
    }
  }
}

OrderBy stringToOrderBy(String? value) {
  return switch (value) {
    'DESC' || 'desc' => OrderBy.DESC,
    'ASC' || 'asc' => OrderBy.ASC,
    _ => throw Exception('Unknown OrderBy. Use "ASC" or "DESC"'),
  };
}
