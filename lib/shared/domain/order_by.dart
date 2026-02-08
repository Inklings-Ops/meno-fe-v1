/// Represents the sort order for query results
enum OrderBy {
  asc('ASC'),
  desc('DESC');

  const OrderBy(this.value);

  final String value;
}
