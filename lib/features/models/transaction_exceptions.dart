class InvalidJumlahException implements Exception {
  final int jumlah;
  const InvalidJumlahException(this.jumlah);

  @override
  String toString() =>
      'Jumlah transaksi harus lebih dari 0, diberikan: $jumlah';
}