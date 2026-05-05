import 'dart:convert';

class Produk {
  final String id;
  final String barcode;
  final String nama;
  final String jenis;
  final String asal;
  final String penjual;
  final String noHp;
  final double harga;
  final String satuan;
  final DateTime tanggalMasuk;
  String status;

  Produk({
    required this.id,
    required this.barcode,
    required this.nama,
    required this.jenis,
    required this.asal,
    required this.penjual,
    required this.noHp,
    required this.harga,
    required this.satuan,
    required this.tanggalMasuk,
    this.status = 'tersedia',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'nama': nama,
      'jenis': jenis,
      'asal': asal,
      'penjual': penjual,
      'noHp': noHp,
      'harga': harga,
      'satuan': satuan,
      'tanggalMasuk': tanggalMasuk.toIso8601String(),
      'status': status,
    };
  }

  factory Produk.fromMap(Map<String, dynamic> m) {
    return Produk(
      id: (m['id'] ?? '').toString(),
      barcode: (m['barcode'] ?? '').toString(),
      nama: (m['nama'] ?? '').toString(),
      jenis: (m['jenis'] ?? '').toString(),
      asal: (m['asal'] ?? '').toString(),
      penjual: (m['penjual'] ?? '').toString(),
      noHp: (m['noHp'] ?? '').toString(),
      harga: ((m['harga'] ?? 0) as num).toDouble(),
      satuan: (m['satuan'] ?? 'kg').toString(),
      tanggalMasuk:
          DateTime.tryParse((m['tanggalMasuk'] ?? '').toString()) ??
              DateTime.now(),
      status: (m['status'] ?? 'tersedia').toString(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Produk.fromJson(String source) =>
      Produk.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
