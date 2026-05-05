import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/produk.dart';
import '../models/penjual.dart';

class LokalService {
  static final LokalService _instance = LokalService._internal();
  factory LokalService() => _instance;
  LokalService._internal();

  static const String _kunciProduk  = 'ps_produk';
  static const String _kunciPenjual = 'ps_penjual';

  // ── PRODUK ────────────────────────────────────────────────

  Future<List<Produk>> semuaProduk() async {
    final prefs = await SharedPreferences.getInstance();
    final list  = prefs.getStringList(_kunciProduk) ?? [];
    return list.map((s) => Produk.fromJson(s)).toList();
  }

  Future<void> simpanProduk(Produk p) async {
    final prefs = await SharedPreferences.getInstance();
    final list  = prefs.getStringList(_kunciProduk) ?? [];
    list.add(p.toJson());
    await prefs.setStringList(_kunciProduk, list);
  }

  Future<Produk?> cariBarcode(String barcode) async {
    final list = await semuaProduk();
    for (final p in list) {
      if (p.barcode == barcode) return p;
    }
    return null;
  }

  Future<void> hapusProduk(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list  = prefs.getStringList(_kunciProduk) ?? [];
    list.removeWhere((s) {
      try {
        final m = jsonDecode(s) as Map<String, dynamic>;
        return m['id'] == id;
      } catch (_) {
        return false;
      }
    });
    await prefs.setStringList(_kunciProduk, list);
  }

  Future<void> updateStatus(String id, String status) async {
    final prefs   = await SharedPreferences.getInstance();
    final list    = prefs.getStringList(_kunciProduk) ?? [];
    final updated = list.map((s) {
      try {
        final m = jsonDecode(s) as Map<String, dynamic>;
        if (m['id'] == id) {
          m['status'] = status;
          return jsonEncode(m);
        }
        return s;
      } catch (_) {
        return s;
      }
    }).toList();
    await prefs.setStringList(_kunciProduk, updated);
  }

  Future<int> hitungProduk() async {
    final list = await semuaProduk();
    return list.length;
  }

  // ── PENJUAL ───────────────────────────────────────────────

  Future<Penjual?> ambilProfil() async {
    final prefs = await SharedPreferences.getInstance();
    final data  = prefs.getString(_kunciPenjual);
    if (data == null || data.isEmpty) return null;
    try {
      return Penjual.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> simpanProfil(Penjual p) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kunciPenjual, p.toJson());
  }
}
