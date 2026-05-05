import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../konstanta.dart';
import '../models/produk.dart';
import '../services/lokal_service.dart';

class DaftarScreen extends StatefulWidget {
  const DaftarScreen({super.key});

  @override
  State<DaftarScreen> createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<DaftarScreen> {
  final _formKey     = GlobalKey<FormState>();
  final _ctrlNama    = TextEditingController();
  final _ctrlAsal    = TextEditingController();
  final _ctrlPenjual = TextEditingController();
  final _ctrlNoHp    = TextEditingController();
  final _ctrlHarga   = TextEditingController();

  String _jenis      = 'ikan_bandeng';
  String _satuan     = 'kg';
  bool   _loading    = false;
  String? _barcodeHasil;

  static const List<Map<String, String>> _daftarJenis = [
    {'key': 'ikan_bandeng',  'label': 'Ikan Bandeng'},
    {'key': 'ikan_kembung',  'label': 'Ikan Kembung'},
    {'key': 'ikan_tongkol',  'label': 'Ikan Tongkol'},
    {'key': 'ikan_kakap',    'label': 'Ikan Kakap Merah'},
    {'key': 'udang_vaname',  'label': 'Udang Vaname'},
    {'key': 'cumi_cumi',     'label': 'Cumi-Cumi'},
    {'key': 'kepiting',      'label': 'Kepiting Bakau'},
    {'key': 'kerang_hijau',  'label': 'Kerang Hijau'},
    {'key': 'bayam',         'label': 'Bayam'},
    {'key': 'kangkung',      'label': 'Kangkung'},
    {'key': 'tomat',         'label': 'Tomat'},
    {'key': 'cabai_merah',   'label': 'Cabai Merah'},
    {'key': 'mangga',        'label': 'Mangga'},
    {'key': 'pisang',        'label': 'Pisang'},
    {'key': 'lainnya',       'label': 'Produk Lainnya'},
  ];

  @override
  void dispose() {
    _ctrlNama.dispose();
    _ctrlAsal.dispose();
    _ctrlPenjual.dispose();
    _ctrlNoHp.dispose();
    _ctrlHarga.dispose();
    super.dispose();
  }

  String _buatBarcode() {
    final now   = DateTime.now();
    final bulan = now.month.toString().padLeft(2, '0');
    final tahun = now.year.toString().substring(2);
    final acak  = const Uuid().v4().substring(0, 4).toUpperCase();
    final kode  = _jenis.substring(0, 2).toUpperCase();
    return 'PS-$kode-$bulan$tahun-$acak';
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final labelJenis = _daftarJenis
        .firstWhere((j) => j['key'] == _jenis,
            orElse: () => {'label': _jenis})['label'] ??
        _jenis;

    final barcode = _buatBarcode();
    final produk  = Produk(
      id:           const Uuid().v4(),
      barcode:      barcode,
      nama:         _ctrlNama.text.trim(),
      jenis:        labelJenis,
      asal:         _ctrlAsal.text.trim(),
      penjual:      _ctrlPenjual.text.trim(),
      noHp:         _ctrlNoHp.text.trim(),
      harga:        double.tryParse(_ctrlHarga.text.trim()) ?? 0,
      satuan:       _satuan,
      tanggalMasuk: DateTime.now(),
    );

    await LokalService().simpanProduk(produk);

    if (!mounted) return;
    setState(() {
      _loading       = false;
      _barcodeHasil  = barcode;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_barcodeHasil != null) return _halamanBerhasil();

    return Scaffold(
      backgroundColor: PsWarna.abuMuda,
      appBar: AppBar(
        title: Text(
          'Daftarkan Produkku',
          style: GoogleFonts.nunito(
            fontSize: PsUkuran.teksBesar,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: PsWarna.biru,
        foregroundColor: PsWarna.putih,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PsUkuran.paddingBesar),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(PsUkuran.radius),
                ),
                child: Text(
                  'Isi data produkmu. Setelah simpan kamu dapat BARCODE unik!',
                  style: GoogleFonts.nunito(
                    fontSize: PsUkuran.teksSedang,
                    color: PsWarna.biru,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _label('Jenis Produk'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: PsWarna.putih,
                  borderRadius: BorderRadius.circular(PsUkuran.radius),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _jenis,
                    isExpanded: true,
                    style: GoogleFonts.nunito(
                      fontSize: PsUkuran.teksSedang,
                      color: PsWarna.hitam,
                    ),
                    items: _daftarJenis
                        .map((j) => DropdownMenuItem(
                              value: j['key'],
                              child: Text(
                                j['label']!,
                                style: GoogleFonts.nunito(
                                    fontSize: PsUkuran.teksSedang),
                              ),
                            ))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _jenis = v ?? _jenis),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _input(
                ctrl: _ctrlNama,
                label: 'Nama Produk',
                hint: 'Contoh: Bandeng Segar Pak Suharto',
                ikon: Icons.inventory_2_rounded,
                wajib: true,
              ),
              _input(
                ctrl: _ctrlAsal,
                label: 'Asal atau Lokasi Tangkap',
                hint: 'Contoh: Tambak Muara Angke, Jakarta',
                ikon: Icons.location_on_rounded,
                wajib: true,
              ),
              _input(
                ctrl: _ctrlPenjual,
                label: 'Nama Penjual atau Nelayan',
                hint: 'Contoh: Pak Suharto',
                ikon: Icons.person_rounded,
                wajib: true,
              ),
              _input(
                ctrl: _ctrlNoHp,
                label: 'Nomor HP atau WhatsApp',
                hint: 'Contoh: 08121234567',
                ikon: Icons.phone_rounded,
                tipe: TextInputType.phone,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _input(
                      ctrl: _ctrlHarga,
                      label: 'Harga',
                      hint: '50000',
                      ikon: Icons.attach_money_rounded,
                      tipe: TextInputType.number,
                      wajib: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Satuan'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12),
                          decoration: BoxDecoration(
                            color: PsWarna.putih,
                            borderRadius:
                                BorderRadius.circular(PsUkuran.radius),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _satuan,
                              isExpanded: true,
                              style: GoogleFonts.nunito(
                                fontSize: PsUkuran.teksSedang,
                                color: PsWarna.hitam,
                              ),
                              items: ['kg', 'ekor', 'ikat', 'pcs', 'lusin']
                                  .map((s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(s,
                                            style: GoogleFonts.nunito(
                                                fontSize:
                                                    PsUkuran.teksSedang)),
                                      ))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _satuan = v ?? _satuan),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: _loading ? null : _simpan,
                icon: _loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: PsWarna.putih,
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(Icons.qr_code_rounded, size: 28),
                label: Text(
                  _loading ? 'Mendaftarkan...' : 'DAFTAR DAN DAPAT BARCODE',
                  style: GoogleFonts.nunito(
                    fontSize: PsUkuran.teksBesar,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PsWarna.biru,
                  foregroundColor: PsWarna.putih,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(PsUkuran.radius),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String teks) {
    return Text(
      teks,
      style: GoogleFonts.nunito(
        fontSize: PsUkuran.teksSedang,
        fontWeight: FontWeight.bold,
        color: PsWarna.hitam,
      ),
    );
  }

  Widget _input({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    required IconData ikon,
    TextInputType tipe = TextInputType.text,
    bool wajib = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: tipe,
          style: GoogleFonts.nunito(fontSize: PsUkuran.teksSedang),
          validator: wajib
              ? (v) => (v == null || v.trim().isEmpty)
                  ? 'Wajib diisi'
                  : null
              : null,
          decoration: InputDecoration(
            hintText: hint,
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
              borderSide: const BorderSide(color: PsWarna.biru, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(PsUkuran.radius),
              borderSide: const BorderSide(color: PsWarna.merah, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(PsUkuran.radius),
              borderSide: const BorderSide(color: PsWarna.merah, width: 2),
            ),
            prefixIcon: Icon(ikon, color: PsWarna.biru, size: 28),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _halamanBerhasil() {
    return Scaffold(
      backgroundColor: PsWarna.hijauPucat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(PsUkuran.paddingBesar),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '🎉',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 24),
              Text(
                'Produk Berhasil\nDidaftarkan!',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: PsUkuran.teksJudul,
                  fontWeight: FontWeight.w900,
                  color: PsWarna.hijau,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Barcode Produkmu:',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: PsUkuran.teksSedang,
                  color: PsWarna.abuTeks,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: PsWarna.putih,
                  borderRadius:
                      BorderRadius.circular(PsUkuran.radiusBesar),
                  boxShadow: [
                    BoxShadow(
                      color: PsWarna.hijau.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '| ||| | || ||| | ||',
                      style: GoogleFonts.nunito(
                        fontSize: 32,
                        letterSpacing: 4,
                        color: PsWarna.hitam,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _barcodeHasil!,
                      style: GoogleFonts.nunito(
                        fontSize: PsUkuran.teksJudul,
                        fontWeight: FontWeight.w900,
                        color: PsWarna.hitam,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Catat dan simpan kode ini!\nBagikan ke pembeli untuk cek info produkmu.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: PsUkuran.teksSedang,
                  color: PsWarna.abuTeks,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home_rounded, size: 28),
                label: Text(
                  'Kembali ke Menu',
                  style: GoogleFonts.nunito(
                    fontSize: PsUkuran.teksBesar,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PsWarna.hijau,
                  foregroundColor: PsWarna.putih,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(PsUkuran.radius),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
