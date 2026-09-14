/// Model dan enum untuk pengurutan data transaksi.
enum DateSortOrder {
  latest('Terbaru'),
  oldest('Terlama');

  final String label;
  const DateSortOrder(this.label);
}

enum PriceSortOrder {
  highest('Tertinggi'),
  lowest('Terendah');

  final String label;
  const PriceSortOrder(this.label);
}

enum SortPriority {
  date,
  price,
}
