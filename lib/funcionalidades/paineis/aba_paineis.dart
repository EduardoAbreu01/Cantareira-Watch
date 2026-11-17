import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/tema/tema_aplicativo.dart';
import '../../core/widgets/banner_decisao_humana.dart';
import '../../core/widgets/card_indicador.dart';
import '../../core/widgets/estado_conteudo.dart';
import '../../core/widgets/grafico_historico_limpo.dart';
import '../../dados/modelos/indicador_territorial.dart';
import '../../estado/provedor_territorial.dart';
import '../../rotas/rotas_aplicativo.dart';

class AbaPaineis extends StatefulWidget {
  const AbaPaineis({super.key});

  @override
  State<AbaPaineis> createState() => _AbaPaineisState();
}

class _AbaPaineisState extends State<AbaPaineis> {
  CategoriaDashboard _categoriaSelecionada = CategoriaDashboard.recursosHidricos;

  String _tituloCategoria(CategoriaDashboard categoria) {
    switch (categoria) {
      case CategoriaDashboard.recursosHidricos:
        return 'Recursos Hídricos';
      case CategoriaDashboard.climaLocal:
        return 'Clima Local';
      case CategoriaDashboard.servicosSociais:
        return 'Demanda & Serviços';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provedor = context.watch<ProvedorTerritorial>();
    final esquema = Theme.of(context).colorScheme;
    final ehEscuro = Theme.of(context).brightness == Brightness.dark;
    final indicadoresFiltrados =
        provedor.indicadoresPorCategoria(_categoriaSelecionada);

    return EstadoConteudo(
      estaCarregando: provedor.estaCarregando,
      mensagemErro: provedor.mensagemErro,
      estaVazio: indicadoresFiltrados.isEmpty,
      filho: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          const BannerDecisaoHumana(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: CategoriaDashboard.values.map((categoria) {
                final selecionada = _categoriaSelecionada == categoria;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_tituloCategoria(categoria)),
                    selected: selecionada,
                    onSelected: (_) {
                      setState(() => _categoriaSelecionada = categoria);
                    },
                    selectedColor: esquema.primary,
                    backgroundColor: esquema.surfaceContainerLowest,
                    checkmarkColor:
                        ehEscuro ? TemaAplicativo.fundoEscuro : Colors.white,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selecionada
                          ? (ehEscuro
                              ? TemaAplicativo.fundoEscuro
                              : Colors.white)
                          : esquema.onSurface,
                    ),
                    side: BorderSide(
                      color: selecionada
                          ? esquema.primary
                          : esquema.outlineVariant,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tendência: ${indicadoresFiltrados.first.titulo}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: esquema.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Toque nos pontos do gráfico para inspecionar cada mês',
                    style: TextStyle(
                      fontSize: 12,
                      color: esquema.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GraficoHistoricoLimpo(
                    pontos: indicadoresFiltrados.first.historico,
                    unidade: indicadoresFiltrados.first.unidade,
                  ),
                ],
              ),
            ),
          ),
          ...indicadoresFiltrados.map(
            (indicador) => CardIndicador(
              indicador: indicador,
              aoTocar: () {
                Navigator.pushNamed(
                  context,
                  RotasAplicativo.detalheIndicador,
                  arguments: indicador,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}