import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../konstanta.dart';
import '../models/penjual.dart';
import '../services/lokal_service.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _ctrlNama     = TextEditingController();
  final _ctrlNoHp     = TextEditingController();
  final _ctrlLokasi   = TextEditingController();
  final _ctrlDeskripsi = TextEditingController();

  String   _jenis      = 'nelayan';
  bool     _loading    = false;
  bool     _sudahAda   = false;
  DateTime _bergabung  = DateTime.now();
  int      _totalProduk = 0;

  @override
  void initState() {
    super.initState();
    _muat();
  }

  @override
  void dispose() {
    _ctrlNama.dispose();
    _ctrlNoHp.dispose();
    _ctrlLokasi.dispose();
    _ctrlDeskripsi.dispose();
    super.dispose();
  }

  Future<void> _muat() async {
    final profil = await LokalService().ambilProfil();
    final total  = await LokalService().hitungProduk();
    if (mounted) {
      setState(() {
        _totalProduk = total;
        if (profil != null) {
          _sudahAda            = true;
          _ctrlNama.text       = profil.nama;
          _ctrlNoHp.text       = profil.noHp;
          _ctrlLokasi.text     = profil.lokasi;
          _ctrlDeskripsi.text  = profil.deskripsi;
          _jenis               = profil.jenis;
          _bergabung           = profil.bergabung;
        }
      });
    }
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final p = Penjual(
      id:        const Uuid().v4(),
      nama:      _ctrlNama.text.trim(),
      noHp:      _ctrlNoHp.text.trim(),
      lokasi:    _ctrlLokasi.text.trim(),
      deskripsi: _ctrlDeskripsi.text.trim(),
      jenis:     _jenis,
      bergabung: _sudahAda ? _bergabung : DateTime.now(),
    );
    await LokalService().simpanProfil(p);

    if (!mounted) return;
    setState(() {
      _loading  = false;
      _sudahAda = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profil berhasil disimpan!',
          style: GoogleFonts.nunito(fontSize: PsUkuran.teksSedang),
        ),
        backgroundColor: PsWarna.hijau,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _emoji() {
    switch (_jenis) {
      case 'nelayan':  return '🎣';
      case 'petani':   return '🌾';
      case 'peternak': return '🐄';
      default:         return '🏪';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PsWarna.abuMuda,
      appBar: AppBar(
        title: Text(
          'Profil Saya',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(PsUkuran.paddingBesar),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [PsWarna.ungu, Color(0xFF7C3AED)],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: PsWarna.putih.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _emoji(),
                        style: const TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _sudahAda && _ctrlNama.text.isNotEmpty
                        ? _ctrlNama.text
                        : 'Nama Belum Diisi',
                    style: GoogleFonts.nunito(
                      fontSize: PsUkuran.teksJudul,
                      fontWeight: FontWeight.w900,
                      color: PsWarna.putih,
                    ),
                  ),
                  if (_ctrlLokasi.text.isNotEmpty)
                    Text(
                      _ctrlLokasi.text,
                      style: GoogleFonts.nunito(
                        fontSize: PsUkuran.teksSedang,
                        color: PsWarna.putih.withOpacity(0.85),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _chip('$_totalProduk', 'Produk'),
                      const SizedBox(width: 12),
                      _chip(
                        _sudahAda
                            ? '${DateTime.now().difference(_bergabung).inDays + 1} hari'
                            : '-',
                        'Bergabung',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(PsUkuran.paddingBesar),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Edit Profil',
                      style: GoogleFonts.nunito(
                        fontSize: PsUkuran.teksBesar,
                        fontWeight: FontWeight.bold,
                        color: PsWarna.hitam,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Jenis Usaha',
                      style: GoogleFonts.nunito(
                        fontSize: PsUkuran.teksSedang,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _pilihanJenis('nelayan',  '🎣 Nelayan'),
                        const SizedBox(width: 8),
                        _pilihanJenis('petani',   '🌾 Petani'),
                        const SizedBox(width: 8),
                        _pilihanJenis('pedagang', '🏪 Pedagang'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _input(
                      ctrl: _ctrlNama,
                      label: 'Nama Lengkap',
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
                      wajib: true,
                    ),
                    _input(
                      ctrl: _ctrlLokasi,
                      label: 'Lokasi atau Alamat Lapak',
                      hint: 'Contoh: Los B No. 12, Muara Angke',
                      ikon: Icons.location_on_rounded,
                      wajib: true,
                    ),
                    _input(
                      ctrl: _ctrlDeskripsi,
                      label: 'Deskripsi Usaha (Opsional)',
                      hint: 'Contoh: Jual ikan segar langsung dari laut',
                      ikon: Icons.info_outline_rounded,
                      maxBaris: 3,
                    ),

                    const SizedBox(height: 24),

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
                          : const Icon(Icons.save_rounded, size: 28),
                      label: Text(
                        _loading ? 'Menyimpan...' : 'SIMPAN PROFIL',
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
                      ),
                    ),

                    if (_sudahAda && _ctrlNoHp.text.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: _ctrlNoHp.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Nomor HP disalin!',
                                style: GoogleFonts.nunito(
                                    fontSize: PsUkuran.teksSedang),
                              ),
                              backgroundColor: PsWarna.ungu,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded),
                        label: Text(
                          'Salin Nomor HP',
                          style: GoogleFonts.nunito(
                            fontSize: PsUkuran.teksSedang,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: PsWarna.hijau,
                          side: const BorderSide(
                              color: PsWarna.hijau, width: 2),
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(PsUkuran.radius),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: PsWarna.unguPucat,
                        borderRadius:
                            BorderRadius.circular(PsUkuran.radius),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tentang Pasarku Sukses',
                            style: GoogleFonts.nunito(
                              fontSize: PsUkuran.teksSedang,
                              fontWeight: FontWeight.bold,
                              color: PsWarna.ungu,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Dibuat khusus untuk nelayan dan petani Indonesia agar bisa bersaing di era digital. Data tersimpan di HP tanpa perlu internet.',
                            style: GoogleFonts.nunito(
                              fontSize: PsUkuran.teksKecil,
                              color: PsWarna.hitam,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Versi 1.0 - Muara Angke MVP',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: PsWarna.abuTeks,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String nilai, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: PsWarna.putih.withOpacity(0.2),
        borderRadius: BorderRadius.circular(PsUkuran.radius),
      ),
      child: Column(
        children: [
          Text(
            nilai,
            style: GoogleFonts.nunito(
              fontSize: PsUkuran.teksBesar,
              fontWeight: FontWeight.w900,
              color: PsWarna.putih,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 13,
              color: PsWarna.putih.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pilihanJenis(String key, String label) {
    final aktif = _jenis == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _jenis = key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: aktif ? PsWarna.ungu : PsWarna.putih,
            borderRadius: BorderRadius.circular(PsUkuran.radius),
            border: Border.all(
              color: aktif ? PsWarna.ungu : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: aktif ? PsWarna.putih : PsWarna.abuTeks,
            ),
          ),
        ),
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
    int maxBaris = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: PsUkuran.teksSedang,
            fontWeight: FontWeight.bold,
            color: PsWarna.hitam,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: tipe,
          maxLines: maxBaris,
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
              borderSide:
                  const BorderSide(color: PsWarna.ungu, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(PsUkuran.radius),
              borderSide:
                  const BorderSide(color: PsWarna.merah, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(PsUkuran.radius),
              borderSide:
                  const BorderSide(color: PsWarna.merah, width: 2),
            ),
            prefixIcon: Icon(ikon, color: PsWarna.ungu, size: 28),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
