import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../konstanta.dart';

class TombolBesar extends StatelessWidget {
  final String label;
  final String keterangan;
  final IconData ikon;
  final Color warna;
  final VoidCallback onTap;

  const TombolBesar({
    super.key,
    required this.label,
    required this.keterangan,
    required this.ikon,
    required this.warna,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(PsUkuran.paddingBesar),
        decoration: BoxDecoration(
          color: warna,
          borderRadius: BorderRadius.circular(PsUkuran.radiusBesar),
          boxShadow: [
            BoxShadow(
              color: warna.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: PsWarna.putih.withOpacity(0.2),
                borderRadius: BorderRadius.circular(PsUkuran.radius),
              ),
              child: Icon(
                ikon,
                color: PsWarna.putih,
                size: PsUkuran.ikonBesar,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.nunito(
                      fontSize: PsUkuran.teksBesar,
                      fontWeight: FontWeight.w900,
                      color: PsWarna.putih,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    keterangan,
                    style: GoogleFonts.nunito(
                      fontSize: PsUkuran.teksKecil,
                      color: PsWarna.putih.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: PsWarna.putih.withOpacity(0.7),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
