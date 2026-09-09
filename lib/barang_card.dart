import 'package:flutter/material.dart';
import 'keranjang_item.dart';

class BarangCard extends StatelessWidget {
  final String nama;
  final int hargaAnggota;
  final int stok;
  final String? kategori;
  final bool? sorot;

  const BarangCard({
    super.key,
    required this.nama,
    required this.hargaAnggota,
    required this.stok,
    this.kategori,
    this.sorot = false,
  });

  IconData getIcon(String kategori) {
    switch (kategori) {
      case 'atk':
        return Icons.edit_note;
      case 'makanan':
        return Icons.lunch_dining;
      case 'minuman':
        return Icons.local_drink;
      case 'inventaris':
        return Icons.inventory_2;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> jumlahItemNotifier = ValueNotifier<int>(1);

    return Card(
      margin: const EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(
              getIcon(kategori ?? 'Umum'),
            ),
            title: Text(
              nama,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text('Anggota Rp$hargaAnggota'),
            trailing: KeranjangItem(
              stok: stok,
              totalHarga: (inputJumlah) {
                // Mengubah nilai notifier tanpa perlu setState / StatefulWidget
                jumlahItemNotifier.value = inputJumlah;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    nama,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: jumlahItemNotifier,
                  builder: (context, jumlah, child) {
                    int totalHargaAktual = hargaAnggota * jumlah;
                    return Text('Total : Rp$totalHargaAktual');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}