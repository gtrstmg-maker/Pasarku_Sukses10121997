import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../konstanta.dart';
import '../models/produk.dart';
import '../services/lokal_service.dart';

class ProdukScreen extends StatefulWidget {
  const ProdukScreen({super.key});

  @override
  State<ProdukScreen> createState() => _ProdukScreenState();
}

class _ProdukScreenState extends State<ProdukScreen> {
  List<Produk> _list   = [];
  bool         _loading = true;

  @override
  void initState() {
    super.initState();
    _muat();
  }

  Future<void> _muat() async {
    setState(() => _loading = true);
    final data = await LokalService().semuaProduk();
    if (mounted) {
      setState(() {
        _list    = data.reversed.toList();
        _loading = false;
      });
    }
  }

  String _rupiah(double angka) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(angka);
  }

  String _tanggal(DateTime t) {
    return DateFormat('d MMM yyyy', 'id_ID').format(t);
  }

  Future<void> _ubahStatus(Produk p) async {
    final baru = p.status == 'tersedia' ? 'habis' : 'tersedia';
    await LokalService().updateStatus(p.id, baru);
    _muat();
  }

  Future<void> _hapus(Produk p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Hapus Produk?',
          style: GoogleFonts.nunito(
            fontSize: PsUkuran.teksBesar,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Produk "${p.nama}" akan dihapus permanen.',
          style: GoogleFonts.nunito(fontSize: PsUkuran.teksSedang),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Batal',
              style: GoogleFonts.nunito(
                fontSize: PsUkuran.teksSedang,
                color: PsWarna.abuTeks,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Hapus',
              style: GoogleFonts.nunito(
                fontSize: PsUkuran.teksSedang,
                fontWeight: FontWeight.bold,
                color: PsWarna.merah,
              ),
            ),
          ),
        ],
      ),
    );
    if (ok == true) {
      await LokalService().hapusProduk(p.id);
      _muat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PsWarna.abuMuda,
      appBar: AppBar(
        title: Text(
          'Produk Saya (${_list.length})',
          style: GoogleFonts.nunito(
            fontSize: PsUkuran.teksBesar,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: PsWarna.coklat,
        foregroundColor: PsWarna.putih,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _muat,
            icon: const Icon(Icons.refresh_rounded, size: 28),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: PsWarna.ungu),
            )
          : _list.isEmpty
              ? _kosong()
              : RefreshIndicator(
                  onRefresh: _muat,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(PsUkuran.padding),
                    itemCount: _list.length,
                    itemBuilder: (_, i) => _kartu(_list[i]),
                  ),
                ),
    );
  }

  Widget _kartu(Produk p) {
    final warna = p.status == 'tersedia' ? PsWarna.hijau : PsWarna.merah;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PsWarna.putih,
        borderRadius: BorderRadius.circular(PsUkuran.radius),
        border: Border(left: BorderSide(color: warna, width: 4)),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  p.nama,
                  style: GoogleFonts.nunito(
                    fontSize: PsUkuran.teksBesar,
                    fontWeight: FontWeight.bold,
                    color: PsWarna.hitam,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: warna.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  p.status == 'tersedia' ? 'Tersedia' : 'Habis',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: warna,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Asal: ${p.asal}',
            style: GoogleFonts.nunito(
              fontSize: PsUkuran.teksSedang,
              color: PsWarna.abuTeks,
            ),
          ),
          Text(
            'Penjual: ${p.penjual}',
            style: GoogleFonts.nunito(
              fontSize: PsUkuran.teksSedang,
              color: PsWarna.abuTeks,
            ),
          ),
          Text(
            'Harga: ${_rupiah(p.harga)} per ${p.satuan}',
            style: GoogleFonts.nunito(
              fontSize: PsUkuran.teksSedang,
              fontWeight: FontWeight.bold,
              color: PsWarna.hitam,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: PsWarna.unguPucat,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Barcode: ${p.barcode}',
              style: GoogleFonts.nunito(
                fontSize: PsUkuran.teksKecil,
                fontWeight: FontWeight.bold,
                color: PsWarna.ungu,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Terdaftar: ${_tanggal(p.tanggalMasuk)}',
            style: GoogleFonts.nunito(
              fontSize: 13,
              color: PsWarna.abuTeks.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _ubahStatus(p),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: warna,
                    side: BorderSide(color: warna),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(PsUkuran.radius),
                    ),
                  ),
                  child: Text(
                    p.status == 'tersedia'
                        ? 'Tandai Habis'
                        : 'Tandai Tersedia',
                    style: GoogleFonts.nunito(
                      fontSize: PsUkuran.teksKecil,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _hapus(p),
                style: OutlinedButton.styleFrom(
                  foregroundColor: PsWarna.merah,
                  side: const BorderSide(color: PsWarna.merah),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(PsUkuran.radius),
                  ),
                ),
                child: const Icon(
                    Icons.delete_outline_rounded, size: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kosong() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PsUkuran.paddingBesar),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📦', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            Text(
              'Belum Ada Produk',
              style: GoogleFonts.nunito(
                fontSize: PsUkuran.teksJudul,
                fontWeight: FontWeight.bold,
                color: PsWarna.hitam,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Daftarkan produk pertamamu\ndan dapatkan barcode!',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: PsUkuran.teksSedang,
                color: PsWarna.abuTeks,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
