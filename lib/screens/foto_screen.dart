import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../konstanta.dart';
import '../models/hasil_analisis.dart';
import '../services/analisis_service.dart';
import 'hasil_screen.dart';

class FotoScreen extends StatefulWidget {
  const FotoScreen({super.key});

  @override
  State<FotoScreen> createState() => _FotoScreenState();
}

class _FotoScreenState extends State<FotoScreen> {
  XFile? _foto;
  bool _analisis = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _ambilFoto(ImageSource src) async {
    try {
      final f = await _picker.pickImage(
        source: src,
        imageQuality: 80,
        maxWidth: 1200,
      );
      if (f != null && mounted) {
        setState(() => _foto = f);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal ambil foto. Coba lagi.',
              style: GoogleFonts.nunito(fontSize: PsUkuran.teksSedang),
            ),
            backgroundColor: PsWarna.merah,
          ),
        );
      }
    }
  }

  void _pilihJenis() {
    if (_foto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ambil foto dulu ya!',
            style: GoogleFonts.nunito(fontSize: PsUkuran.teksSedang),
          ),
          backgroundColor: PsWarna.merah,
        ),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PilihJenis(
        onPilih: (key) {
          Navigator.pop(context);
          _jalankanAnalisis(key);
        },
      ),
    );
  }

  Future<void> _jalankanAnalisis(String key) async {
    setState(() => _analisis = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    final HasilAnalisis? hasil = AnalisisService().analisis(key);
    if (!mounted) return;
    setState(() => _analisis = false);
    if (hasil != null && _foto != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HasilScreen(
            hasil: hasil,
            fotoPath: _foto!.path,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PsWarna.abuMuda,
      appBar: AppBar(
        title: Text(
          'Foto dan Analisis Makanan',
          style: GoogleFonts.nunito(
            fontSize: PsUkuran.teksBesar,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: PsWarna.ungu,
        foregroundColor: PsWarna.putih,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: _analisis ? _loading() : _body(),
    );
  }

  Widget _loading() {
    return Container(
      color: PsWarna.unguPucat,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                color: PsWarna.ungu,
                strokeWidth: 6,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'AI sedang menganalisis...',
              style: GoogleFonts.nunito(
                fontSize: PsUkuran.teksBesar,
                fontWeight: FontWeight.bold,
                color: PsWarna.ungu,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Mohon tunggu sebentar',
              style: GoogleFonts.nunito(
                fontSize: PsUkuran.teksSedang,
                color: PsWarna.abuTeks,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(PsUkuran.paddingBesar),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => _ambilFoto(ImageSource.camera),
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                color: PsWarna.putih,
                borderRadius:
                    BorderRadius.circular(PsUkuran.radiusBesar),
                border: Border.all(
                  color: _foto != null
                      ? PsWarna.hijau
                      : PsWarna.ungu.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _foto != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                          PsUkuran.radiusBesar - 2),
                      child: Image.file(
                        File(_foto!.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          size: 72,
                          color: PsWarna.ungu.withOpacity(0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ketuk untuk foto makanan',
                          style: GoogleFonts.nunito(
                            fontSize: PsUkuran.teksBesar,
                            fontWeight: FontWeight.bold,
                            color: PsWarna.ungu.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Arahkan kamera ke ikan, sayur, atau buah',
                          style: GoogleFonts.nunito(
                            fontSize: PsUkuran.teksKecil,
                            color: PsWarna.abuTeks,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _ambilFoto(ImageSource.gallery),
            icon: const Icon(Icons.photo_library_rounded),
            label: Text(
              'Pilih dari Galeri',
              style: GoogleFonts.nunito(
                fontSize: PsUkuran.teksSedang,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: PsWarna.ungu,
              side: const BorderSide(color: PsWarna.ungu, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PsUkuran.radius),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (_foto == null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PsWarna.hijauPucat,
                borderRadius: BorderRadius.circular(PsUkuran.radius),
                border: Border.all(
                    color: PsWarna.hijau.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tips foto yang bagus:',
                    style: GoogleFonts.nunito(
                      fontSize: PsUkuran.teksSedang,
                      fontWeight: FontWeight.bold,
                      color: PsWarna.hijau,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _tip('Cahaya terang, jangan backlight'),
                  _tip('Dekat ke makanan agar jelas terlihat'),
                  _tip('Satu jenis makanan per foto'),
                  _tip('Latar belakang bersih dan rapi'),
                ],
              ),
            ),
          ],
          if (_foto != null) ...[
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _pilihJenis,
              icon: const Icon(Icons.search_rounded, size: 28),
              label: Text(
                'ANALISIS SEKARANG!',
                style: GoogleFonts.nunito(
                  fontSize: PsUkuran.teksBesar,
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: PsWarna.ungu,
                foregroundColor: PsWarna.putih,
                padding:
                    const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(PsUkuran.radius),
                ),
                elevation: 4,
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _tip(String teks) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('  ✅  ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              teks,
              style: GoogleFonts.nunito(
                fontSize: PsUkuran.teksKecil,
                color: PsWarna.hitam,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PilihJenis extends StatelessWidget {
  final Function(String key) onPilih;

  const _PilihJenis({required this.onPilih});

  @override
  Widget build(BuildContext context) {
    final daftar = AnalisisService.daftarPilihan();
    final grupUrutan = [
      'Ikan dan Seafood',
      'Sayuran',
      'Bumbu',
      'Buah',
    ];

    return Container(
      decoration: const BoxDecoration(
        color: PsWarna.putih,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.all(PsUkuran.paddingBesar),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Ini makanan apa?',
            style: GoogleFonts.nunito(
              fontSize: PsUkuran.teksJudul,
              fontWeight: FontWeight.w900,
              color: PsWarna.hitam,
            ),
          ),
          Text(
            'Pilih jenis makanan yang kamu foto:',
            style: GoogleFonts.nunito(
              fontSize: PsUkuran.teksSedang,
              color: PsWarna.abuTeks,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: grupUrutan.map((grup) {
                  final items = daftar
                      .where((d) => d['grup'] == grup)
                      .toList();
                  if (items.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          grup,
                          style: GoogleFonts.nunito(
                            fontSize: PsUkuran.teksKecil,
                            fontWeight: FontWeight.bold,
                            color: PsWarna.abuTeks,
                          ),
                        ),
                      ),
                      ...items.map((item) => _itemPilih(item)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _itemPilih(Map<String, String> item) {
    return Builder(
      builder: (ctx) => GestureDetector(
        onTap: () => onPilih(item['key']!),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: PsWarna.abuMuda,
            borderRadius: BorderRadius.circular(PsUkuran.radius),
            border: Border.all(
                color: PsWarna.ungu.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              Text(
                item['emoji']!,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 16),
              Text(
                item['label']!,
                style: GoogleFonts.nunito(
                  fontSize: PsUkuran.teksBesar,
                  fontWeight: FontWeight.bold,
                  color: PsWarna.hitam,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: PsWarna.ungu,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
