  import 'package:flutter/material.dart';

  class KeranjangItem extends StatefulWidget{
    final int stok;
    final Function(int) totalHarga;

    const KeranjangItem({
      super.key,
      required this.stok,    
      required this.totalHarga
    });

    @override
    State<KeranjangItem> createState() => _KeranjangItemState();
  }

  class _KeranjangItemState extends State<KeranjangItem> {
    int jumlah = 1;

    void _updateJumlah(int inputJumlah) {
      setState(() {
        jumlah = inputJumlah;
      });
      widget.totalHarga(inputJumlah);
    }

    @override
    void initState() {
      super.initState();
    }

    @override
    void dispose() {
      super.dispose();
    }
    
    Widget build(BuildContext context) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              if (jumlah > 0) {
                _updateJumlah(jumlah - 1);
              }
              print(jumlah);
            }
          ),
          Text(jumlah.toString()),
          IconButton(icon: const Icon(Icons.add),
          onPressed: () {
            if (jumlah < widget.stok) {
              _updateJumlah(jumlah + 1); 
            }
            print(jumlah);
          })
        ],
      );
    }
  }