import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../konstanta.dart';
import '../models/hasil_analisis.dart';

class HasilScreen extends StatelessWidget {
  final HasilAnalisis hasil;
  final String fotoPath;

  const HasilScreen({
    super.key,
    required this.hasil,
    required this.fotoPath,
  });

  Color get _warnaLabel {
    switch (hasil.warnaLabel) {
      case 'hijau':
        return PsWarna.hijau;
      case 'kuning':
        return PsWarna.kuning;
      case 'merah':
        return PsWarna.merah;
      default:
        return PsWarna.hijau;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PsWarna.abuMuda,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: PsWarna.ungu,
            foregroundColor: PsWarna.putih,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                hasil.nama,
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: PsWarna.putih,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(fotoPath),
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(PsUkuran.paddingBesar),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _skor(),
                  const SizedBox(height: 16),
                  _kartu(
                    judul: 'Informasi Dasar',
                    warnaGaris: PsWarna.ungu,
                    isi: _infodasar(),
                  ),
                  const SizedBox(height: 16),
                  _kartu(
                    judul: 'Kandungan Gizi per 100g',
                    warnaGaris: PsWarna.hijau,
                    isi: _nutrisi(),
                  ),
                  const SizedBox(height: 16),
                  _kartu(
                    judul: 'Manfaat Kesehatan',
                    warnaGaris: PsWarna.hijau,
                    isi: _listItem(hasil.manfaatKesehatan, prefix: 'baik'),
                  ),
                  const SizedBox(height: 16),
                  _kartu(
                    judul: 'Cara Menyimpan',
                    warnaGaris: PsWarna.biru,
                    isi: _listItem(hasil.tipsSimpan),
                  ),
                  const SizedBox(height: 16),
                  _kartu(
                    judul: 'Cara Mengolah',
                    warnaGaris: PsWarna.coklat,
                    isi: _listItem(hasil.caraOlah),
                  ),
                  if (hasil.peringatan.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _kartu(
                      judul: 'Peringatan Penting',
                      warnaGaris: PsWarna.merah,
                      warnaLatar: const Color(0xFFFEF2F2),
                      isi: _listItem(hasil.peringatan),
                    ),
                  ],
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                        Icons.camera_alt_rounded, size: 26),
                    label: Text(
                      'Foto Makanan Lain',
                      style: GoogleFonts.nunito(
                        fontSize: PsUkuran.teksBesar,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PsWarna.ungu,
                      foregroundColor: PsWarna.putih,
                      padding:
                          const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(PsUkuran.radius),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skor() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_warnaLabel, _warnaLabel.withOpacity(0.75)],
        ),
        borderRadius: BorderRadius.circular(PsUkuran.radiusBesar),
        boxShadow: [
          BoxShadow(
            color: _warnaLabel.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: hasil.skorKesegaran / 100,
                  backgroundColor: PsWarna.putih.withOpacity(0.3),
                  color: PsWarna.putih,
                  strokeWidth: 8,
                ),
                Text(
                  '${hasil.skorKesegaran}',
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: PsWarna.putih,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tingkat Kesegaran',
                  style: GoogleFonts.nunito(
                    fontSize: PsUkuran.teksKecil,
                    color: PsWarna.putih.withOpacity(0.85),
                  ),
                ),
                Text(
                  hasil.labelKesegaran,
                  style: GoogleFonts.nunito(
                    fontSize: PsUkuran.teksJudul,
                    fontWeight: FontWeight.w900,
                    color: PsWarna.putih,
                  ),
                ),
                Text(
                  'Skor AI: ${hasil.skorKesegaran} dari 100',
                  style: GoogleFonts.nunito(
                    fontSize: PsUkuran.teksKecil,
                    color: PsWarna.putih.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartu({
    required String judul,
    required Color warnaGaris,
    required Widget isi,
    Color warnaLatar = PsWarna.putih,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: warnaLatar,
        borderRadius: BorderRadius.circular(PsUkuran.radius),
        border: Border(
          left: BorderSide(color: warnaGaris, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul,
            style: GoogleFonts.nunito(
              fontSize: PsUkuran.teksBesar,
              fontWeight: FontWeight.bold,
              color: PsWarna.hitam,
            ),
          ),
          const SizedBox(height: 12),
          isi,
        ],
      ),
    );
  }

  Widget _infodasar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _baris('Nama Ilmiah', hasil.namaIlmiah),
        _baris('Jenis', hasil.jenis),
        _baris('Asal', hasil.asal),
        _baris('Musim Terbaik', hasil.musimTerbaik),
        _baris('Harga Estimasi', hasil.hargaEstimasi),
      ],
    );
  }

  Widget _baris(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: PsUkuran.teksKecil,
                color: PsWarna.abuTeks,
              ),
            ),
          ),
          Expanded(
            child: Text(
              nilai,
              style: GoogleFonts.nunito(
                fontSize: PsUkuran.teksKecil,
                fontWeight: FontWeight.bold,
                color: PsWarna.hitam,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nutrisi() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: hasil.nutrisiPer100g.entries.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: PsWarna.unguPucat,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
                color: PsWarna.ungu.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                e.value,
                style: GoogleFonts.nunito(
                  fontSize: PsUkuran.teksSedang,
                  fontWeight: FontWeight.w900,
                  color: PsWarna.ungu,
                ),
              ),
              Text(
                e.key,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  color: PsWarna.abuTeks,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _listItem(List<String> items, {String prefix = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((t) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            t,
            style: GoogleFonts.nunito(
              fontSize: PsUkuran.teksSedang,
              color: PsWarna.hitam,
              height: 1.4,
            ),
          ),
        );
      }).toList(),
    );
  }
}
