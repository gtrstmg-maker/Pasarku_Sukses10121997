import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../konstanta.dart';
import '../services/lokal_service.dart';
import '../widgets/tombol_besar.dart';
import 'foto_screen.dart';
import 'scan_screen.dart';
import 'daftar_screen.dart';
import 'produk_screen.dart';
import 'profil_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _tab = 0;
  int _totalProduk = 0;
  String _namaPenjual = '';

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  Future<void> _muatData() async {
    final total  = await LokalService().hitungProduk();
    final profil = await LokalService().ambilProfil();
    if (mounted) {
      setState(() {
        _totalProduk = total;
        _namaPenjual = profil?.nama ?? '';
      });
    }
  }

  String _sapaan() {
    final jam = DateTime.now().hour;
    if (jam < 11) return 'Selamat Pagi';
    if (jam < 15) return 'Selamat Siang';
    if (jam < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  Widget _beranda() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [PsWarna.ungu, Color(0xFF7C3AED)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_sapaan()} 🎣',
                          style: GoogleFonts.nunito(
                            fontSize: PsUkuran.teksKecil,
                            color: PsWarna.putih.withOpacity(0.85),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _namaPenjual.isEmpty
                              ? 'Pasarku Sukses'
                              : _namaPenjual,
                          style: GoogleFonts.nunito(
                            fontSize: PsUkuran.teksJudul,
                            fontWeight: FontWeight.w900,
                            color: PsWarna.putih,
                          ),
                        ),
                        Text(
                          'Muara Angke, Jakarta Utara',
                          style: GoogleFonts.nunito(
                            fontSize: PsUkuran.teksKecil,
                            color: PsWarna.putih.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: PsWarna.putih.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$_totalProduk',
                          style: GoogleFonts.nunito(
                            fontSize: PsUkuran.teksJudul,
                            fontWeight: FontWeight.w900,
                            color: PsWarna.putih,
                          ),
                        ),
                        Text(
                          'Produk',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: PsWarna.putih.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: PsWarna.putih.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(PsUkuran.radius),
                ),
                child: Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Foto makananmu, AI kasih info lengkap gratis!',
                        style: GoogleFonts.nunito(
                          fontSize: PsUkuran.teksKecil,
                          color: PsWarna.putih,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(PsUkuran.paddingBesar),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Mau ngapain hari ini?',
                  style: GoogleFonts.nunito(
                    fontSize: PsUkuran.teksBesar,
                    fontWeight: FontWeight.bold,
                    color: PsWarna.hitam,
                  ),
                ),
                const SizedBox(height: 20),
                TombolBesar(
                  label: 'Foto dan Analisis Makanan',
                  keterangan:
                      'Foto ikan, sayur, buah lalu AI kasih info lengkap',
                  ikon: Icons.camera_alt_rounded,
                  warna: PsWarna.ungu,
                  onTap: () => setState(() => _tab = 1),
                ),
                TombolBesar(
                  label: 'Scan atau Cek Barcode',
                  keterangan:
                      'Ketik barcode produk lalu lihat info lengkapnya',
                  ikon: Icons.qr_code_scanner_rounded,
                  warna: PsWarna.hijau,
                  onTap: () => setState(() => _tab = 2),
                ),
                TombolBesar(
                  label: 'Daftarkan Produkku',
                  keterangan: 'Daftarkan produk dan dapatkan barcode unik',
                  ikon: Icons.add_box_rounded,
                  warna: PsWarna.biru,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DaftarScreen()),
                    ).then((_) => _muatData());
                  },
                ),
                TombolBesar(
                  label: 'Produk Saya',
                  keterangan: 'Lihat dan kelola semua produk yang terdaftar',
                  ikon: Icons.inventory_2_rounded,
                  warna: PsWarna.coklat,
                  onTap: () => setState(() => _tab = 3),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Untuk Nelayan dan Petani Indonesia',
                    style: GoogleFonts.nunito(
                      fontSize: PsUkuran.teksKecil,
                      color: PsWarna.abuTeks,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Versi 1.0 - Muara Angke MVP',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: PsWarna.abuTeks.withOpacity(0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> halaman = [
      _beranda(),
      const FotoScreen(),
      const ScanScreen(),
      const ProdukScreen(),
      const ProfilScreen(),
    ];

    return Scaffold(
      backgroundColor: PsWarna.abuMuda,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _tab,
          children: halaman,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) {
          setState(() => _tab = i);
          if (i == 0) _muatData();
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: PsWarna.ungu,
        unselectedItemColor: PsWarna.abuTeks,
        backgroundColor: PsWarna.putih,
        selectedLabelStyle: GoogleFonts.nunito(
            fontSize: 13, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.nunito(fontSize: 12),
        iconSize: 28,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_rounded), label: 'Foto AI'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner_rounded), label: 'Scan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_rounded), label: 'Produk'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}
