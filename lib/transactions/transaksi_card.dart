import 'package:flutter/material.dart';
import '../main.dart';

class TransaksiCard extends StatelessWidget {
  final String keterangan;
  final String jenis;
  final String kategori;
  final int jumlah;
  final String tanggal;

  TransaksiCard({
    super.key,
    required this.keterangan,
    required this.jenis,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(keterangan),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jenis: $jenis'),
            Text('Kategori: $kategori'),
            Text('Jumlah: $jumlah'),
            Text('Tanggal: $tanggal'),
          ],
        ),
      ),
    );
  }
}
