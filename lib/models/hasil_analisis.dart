class HasilAnalisis {
  final String nama;
  final String namaIlmiah;
  final String jenis;
  final String asal;
  final String deskripsi;
  final int skorKesegaran;
  final String labelKesegaran;
  final String warnaLabel;
  final Map<String, String> nutrisiPer100g;
  final List<String> manfaatKesehatan;
  final List<String> tipsSimpan;
  final List<String> caraOlah;
  final List<String> peringatan;
  final String musimTerbaik;
  final String hargaEstimasi;

  const HasilAnalisis({
    required this.nama,
    required this.namaIlmiah,
    required this.jenis,
    required this.asal,
    required this.deskripsi,
    required this.skorKesegaran,
    required this.labelKesegaran,
    required this.warnaLabel,
    required this.nutrisiPer100g,
    required this.manfaatKesehatan,
    required this.tipsSimpan,
    required this.caraOlah,
    required this.peringatan,
    required this.musimTerbaik,
    required this.hargaEstimasi,
  });
}
