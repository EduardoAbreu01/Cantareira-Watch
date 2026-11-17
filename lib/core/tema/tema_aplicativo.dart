import 'package:flutter/material.dart';

class TemaAplicativo {
  // Cores semânticas compartilhadas
  static const Color azulPrimario = Color(0xFF0A2540);
  static const Color azulMedio = Color(0xFF0F4C81);
  static const Color cianoSecundario = Color(0xFF0284C7);
  static const Color cianoBrilho = Color(0xFF38BDF8);
  static const Color ambarAlerta = Color(0xFF6366F1);
  static const Color vermelhoPerigo = Color(0xFFDC2626);
  static const Color verdeSucesso = Color(0xFF059669);

  // Tokens Modo Claro
  static const Color fundoClaro = Color(0xFFF1F5F9);
  static const Color bordaSutil = Color(0xFFE2E8F0);
  static const Color textoPrincipal = Color(0xFF0F172A);
  static const Color textoSecundario = Color(0xFF64748B);

  // Tokens Modo EscuroR
  static const Color fundoEscuro = Color(0xFF0B1120);
  static const Color cardEscuro = Color(0xFF151F32);
  static const Color bordaEscura = Color(0xFF26334D);
  static const Color textoPrincipalEscuro = Color(0xFFF1F5F9);
  static const Color textoSecundarioEscuro = Color(0xFF94A3B8);

  static const LinearGradient gradienteHeroHidro = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A2540),
      Color(0xFF0F4C81),
      Color(0xFF0369A1),
    ],
  );

  static ThemeData get temaClaro {
    const esquemaCores = ColorScheme.light(
      primary: azulPrimario,
      secondary: cianoSecundario,
      surface: fundoClaro,
      surfaceContainerLowest: Colors.white,
      onSurface: textoPrincipal,
      onSurfaceVariant: textoSecundario,
      outlineVariant: bordaSutil,
    );

    return _construirTema(esquemaCores);
  }

  static ThemeData get temaEscuro {
    const esquemaCores = ColorScheme.dark(
      primary: cianoBrilho,
      secondary: cianoSecundario,
      surface: fundoEscuro,
      surfaceContainerLowest: cardEscuro,
      onSurface: textoPrincipalEscuro,
      onSurfaceVariant: textoSecundarioEscuro,
      outlineVariant: bordaEscura,
    );

    return _construirTema(esquemaCores);
  }

  static ThemeData _construirTema(ColorScheme esquemaCores) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: esquemaCores,
      scaffoldBackgroundColor: esquemaCores.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: esquemaCores.surface,
        foregroundColor: esquemaCores.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: esquemaCores.surfaceContainerLowest,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: esquemaCores.outlineVariant, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: esquemaCores.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: esquemaCores.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: esquemaCores.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: esquemaCores.primary, width: 1.5),
        ),
      ),
    );
  }
}