import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'konstanta.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const PasarkuSuksesApp());
}

class PasarkuSuksesApp extends StatelessWidget {
  const PasarkuSuksesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pasarku Sukses',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: PsWarna.ungu,
          primary: PsWarna.ungu,
          secondary: PsWarna.hijau,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: PsWarna.abuMuda,
        appBarTheme: AppBarTheme(
          centerTitle: false,
          elevation: 0,
          titleTextStyle: GoogleFonts.nunito(
            fontSize: PsUkuran.teksBesar,
            fontWeight: FontWeight.bold,
            color: PsWarna.putih,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(
                double.infinity, PsUkuran.tombolTinggi),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(PsUkuran.radius),
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
