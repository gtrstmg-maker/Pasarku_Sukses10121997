import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../konstanta.dart';
import '../models/produk.dart';
import '../services/lokal_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _ctrl = TextEditingController();
  Produk? _ditemukan;
  bool _tidakAda = false;
  bool _loading = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _cari() async {
    final kode = _ctrl.text.trim();
    if (kode.isEmpty) return;
    setState(() {
      _loading = true;
      _ditemukan = null;
      _tidakAda = false;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    final produk = await LokalService().cariBarcode(kode);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _ditemukan = produk;
      _tidakAda = produk == null;
    });
  }

  void _reset() {
    _ctrl.clear();
    setState(() {
      _ditemukan = null;
      _tidakAda = false;
    });
  }

  String _rupiah(double angka) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(angka);
  }

  String _tanggal(DateTime t) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PsWarna.abuMuda,
      appBar: AppBar(
        title: Text(
          'Scan atau Cek Barcode',
          style: GoogleFonts.nunito(
            fontSize: PsUkuran.teksBesar,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: PsWarna.hijau,
        foregroundColor: PsWarna.putih,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PsUkuran.paddingBesar),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PsWarna.hijauPucat,
                borderRadius: BorderRadius.circular(PsUkuran.radius),
                border: Border.all(
                    color: PsWarna.hijau.withOpacity(0.3)),
              ),
              child: Text(
                'Ketik nomor barcode produk untuk melihat informasi lengkapnya.',
                style: GoogleFonts.nunito(
                  fontSize: PsUkuran.teksSedang,
                  color: PsWarna.hijau,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _ctrl,
              style: GoogleFonts.nunito(
                fontSize: PsUkuran.teksBesar,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                labelText: 'Nomor Barcode',
                labelStyle: GoogleFonts.nunito(
                  fontSize: PsUkuran.teksSedang,
                  color: PsWarna.abuTeks,
                ),
                hintText: 'Contoh: PS-IK-042025-AB12',
                hintStyle: GoogleFonts.nunito(
                  fontSize: PsUkuran.teksSedang,
                  color: PsWarna.abuTeks.withOpacity(0.5),
                ),
                filled: true,
                fillColor: PsWarna.putih,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(PsUkuran.radius),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(PsUkuran.radius),
                  borderSide:
                      const BorderSide(color: PsWarna.hijau, width: 2),
                ),
                prefixIcon: const Icon(
                  Icons.qr_code_rounded,
                  color: PsWarna.hijau,
                  size: 32,
                ),
                suffixIcon: _ctrl.text.isNotEmpty
                    ? IconButton(
                        onPressed: _reset,
                        icon: const Icon(Icons.clear_rounded),
                      )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _cari(),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loading ? null : _cari,
              icon: _loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: PsWarna.putih,
                        strokeWidth: 3,
                      ),
                    )
                  : const Icon(Icons.search_rounded, size: 28),
              label: Text(
                _loading ? 'Mencari...' : 'CARI PRODUK',
                style: GoogleFonts.nunito(
                  fontSize: PsUkuran.teksBesar,
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: PsWarna.hijau,
                foregroundColor: PsWarna.putih,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(PsUkuran.radius),
                ),
                elevation: 4,
              ),
            ),
            const SizedBox(height: 24),
            if (_ditemukan != null) _kartuProduk(_ditemukan!),
            if (_tidakAda) _tampilTidakAda(),
          ],
        ),
      ),
    );
  }

  Widget _kartuProduk(Produk p) {
    final warna = p.status == 'tersedia' ? PsWarna.hijau : PsWarna.merah;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PsWarna.putih,
        borderRadius: BorderRadius.circular(PsUkuran.radiusBesar),
        border: Border(left: BorderSide(color: warna, width: 5)),
        boxShadow: [
          BoxShadow(
            color: warna.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produk Ditemukan!',
            style: GoogleFonts.nunito(
              fontSize: PsUkuran.teksBesar,
              fontWeight: FontWeight.bold,
              color: PsWarna.hijau,
            ),
          ),
          const Divider(height: 24),
          _baris('Nama Produk', p.nama),
          _baris('Jenis', p.jenis),
          _baris('Asal', p.asal),
          _baris('Penjual', p.penjual),
          _baris('Nomor HP', p.noHp.isEmpty ? '-' : p.noHp),
          _baris('Harga', '${_rupiah(p.harga)} per ${p.satuan}'),
          _baris('Tgl Masuk', _tanggal(p.tanggalMasuk)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: warna.withOpacity(0.1),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              p.status == 'tersedia' ? 'TERSEDIA' : 'HABIS',
              style: GoogleFonts.nunito(
                fontSize: PsUkuran.teksSedang,
                fontWeight: FontWeight.bold,
                color: warna,
              ),
            ),
          ),
        ],
      ),
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
                fontSize: PsUkuran.teksSedang,
                fontWeight: FontWeight.bold,
                color: PsWarna.hitam,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tampilTidakAda() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: PsWarna.putih,
        borderRadius: BorderRadius.circular(PsUkuran.radiusBesar),
        border: Border.all(color: PsWarna.merah.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text('😔', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(
            'Produk Tidak Ditemukan',
            style: GoogleFonts.nunito(
              fontSize: PsUkuran.teksBesar,
              fontWeight: FontWeight.bold,
              color: PsWarna.merah,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Barcode belum terdaftar.\nMinta penjual untuk mendaftarkan produknya.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: PsUkuran.teksSedang,
              color: PsWarna.abuTeks,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
