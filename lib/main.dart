import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/tema/tema_aplicativo.dart';
import 'estado/provedor_territorial.dart';
import 'funcionalidades/consentimento/tela_consentimento.dart';
import 'funcionalidades/principal/tela_principal_abas.dart';
import 'rotas/rotas_aplicativo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProvedorTerritorial()..inicializar(),
      child: const AplicativoCantareira(),
    ),
  );
}

class AplicativoCantareira extends StatelessWidget {
  const AplicativoCantareira({super.key});

  @override
  Widget build(BuildContext context) {
    final provedor = context.watch<ProvedorTerritorial>();

    return MaterialApp(
      title: 'Cantareira Watch',
      debugShowCheckedModeBanner: false,
      theme: TemaAplicativo.temaClaro,
      darkTheme: TemaAplicativo.temaEscuro,
      themeMode: provedor.modoEscuro ? ThemeMode.dark : ThemeMode.light,
      onGenerateRoute: RotasAplicativo.gerarRota,
      home: provedor.estaCarregando
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : (provedor.consentimentoAceito
              ? const TelaPrincipalAbas()
              : const TelaConsentimento()),
    );
  }
}