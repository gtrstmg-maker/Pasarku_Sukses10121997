import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../konstanta.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _ctrl.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [PsWarna.ungu, Color(0xFF4C1D95)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: PsWarna.putih.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: const Center(
                        child: Text(
                          '\u{1F33E}',
                          style: TextStyle(fontSize: 64),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Pasarku Sukses',
                      style: GoogleFonts.nunito(
                        fontSize: PsUkuran.teksHero,
                        fontWeight: FontWeight.w900,
                        color: PsWarna.putih,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pasar Digital Nelayan dan Petani\nIndonesia',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: PsUkuran.teksSedang,
                        color: PsWarna.putih.withOpacity(0.85),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Muara Angke, Jakarta Utara',
                      style: GoogleFonts.nunito(
                        fontSize: PsUkuran.teksKecil,
                        color: PsWarna.putih.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 56),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: PsWarna.putih.withOpacity(0.6),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
