import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/banner_decisao_humana.dart';
import '../../core/widgets/card_alerta.dart';
import '../../core/widgets/estado_conteudo.dart';
import '../../estado/provedor_territorial.dart';
import '../../rotas/rotas_aplicativo.dart';

class AbaAlertas extends StatelessWidget {
  const AbaAlertas({super.key});

  @override
  Widget build(BuildContext context) {
    final provedor = context.watch<ProvedorTerritorial>();
    final alertas = provedor.alertasAtivos;

    return EstadoConteudo(
      estaCarregando: provedor.estaCarregando,
      mensagemErro: provedor.mensagemErro,
      estaVazio: alertas.isEmpty,
      mensagemVazio:
          'Nenhum alerta ativo para os limiares configurados atualmente.',
      filho: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const BannerDecisaoHumana(),
          ...alertas.map(
            (alerta) => CardAlerta(
              alerta: alerta,
              aoTocar: () {
                Navigator.pushNamed(
                  context,
                  RotasAplicativo.detalheAlerta,
                  arguments: alerta,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}