import 'package:flutter/material.dart';
import '../dados/modelos/alerta_preditivo.dart';
import '../dados/modelos/indicador_territorial.dart';
import '../funcionalidades/alertas/tela_detalhe_alerta.dart';
import '../funcionalidades/consentimento/tela_consentimento.dart';
import '../funcionalidades/paineis/tela_detalhe_indicador.dart';
import '../funcionalidades/principal/tela_principal_abas.dart';

class RotasAplicativo {
  static const String consentimento = '/consentimento';
  static const String principal = '/principal';
  static const String detalheIndicador = '/detalhe-indicador';
  static const String detalheAlerta = '/detalhe-alerta';

  static Route<dynamic> gerarRota(RouteSettings configuracoes) {
    switch (configuracoes.name) {
      case consentimento:
        return MaterialPageRoute(builder: (_) => const TelaConsentimento());

      case principal:
        return MaterialPageRoute(builder: (_) => const TelaPrincipalAbas());

      case detalheIndicador:
        final indicador = configuracoes.arguments as IndicadorTerritorial;
        return MaterialPageRoute(
          builder: (_) => TelaDetalheIndicador(indicador: indicador),
        );

      case detalheAlerta:
        final alerta = configuracoes.arguments as AlertaPreditivo;
        return MaterialPageRoute(
          builder: (_) => TelaDetalheAlerta(alerta: alerta),
        );

      default:
        return MaterialPageRoute(builder: (_) => const TelaPrincipalAbas());
    }
  }
}