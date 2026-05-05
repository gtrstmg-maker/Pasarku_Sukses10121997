import 'dart:convert';

class Penjual {
  String id;
  String nama;
  String noHp;
  String lokasi;
  String deskripsi;
  String jenis;
  DateTime bergabung;

  Penjual({
    required this.id,
    required this.nama,
    required this.noHp,
    required this.lokasi,
    required this.deskripsi,
    required this.jenis,
    required this.bergabung,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'noHp': noHp,
      'lokasi': lokasi,
      'deskripsi': deskripsi,
      'jenis': jenis,
      'bergabung': bergabung.toIso8601String(),
    };
  }

  factory Penjual.fromMap(Map<String, dynamic> m) {
    return Penjual(
      id: (m['id'] ?? '').toString(),
      nama: (m['nama'] ?? '').toString(),
      noHp: (m['noHp'] ?? '').toString(),
      lokasi: (m['lokasi'] ?? '').toString(),
      deskripsi: (m['deskripsi'] ?? '').toString(),
      jenis: (m['jenis'] ?? 'nelayan').toString(),
      bergabung:
          DateTime.tryParse((m['bergabung'] ?? '').toString()) ??
              DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Penjual.fromJson(String source) =>
      Penjual.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
