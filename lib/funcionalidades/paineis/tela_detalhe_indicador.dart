import 'package:flutter/material.dart';
import '../../core/tema/tema_aplicativo.dart';
import '../../core/widgets/banner_decisao_humana.dart';
import '../../core/widgets/grafico_historico_limpo.dart';
import '../../dados/modelos/indicador_territorial.dart';

class TelaDetalheIndicador extends StatelessWidget {
  final IndicadorTerritorial indicador;

  const TelaDetalheIndicador({super.key, required this.indicador});

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final corTendencia = indicador.tendenciaPositiva
        ? TemaAplicativo.verdeSucesso
        : TemaAplicativo.vermelhoPerigo;
    final sinal = indicador.tendenciaPositiva ? '+' : '';

    return Scaffold(
      appBar: AppBar(title: Text(indicador.titulo)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const BannerDecisaoHumana(),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      indicador.subtitulo,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: esquema.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          indicador.valorAtual.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: esquema.onSurface,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          indicador.unidade,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: esquema.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: corTendencia.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$sinal${indicador.variacaoPercentual.toStringAsFixed(1)}% no período',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: corTendencia,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Evolução Histórica (6 meses)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: esquema.onSurface,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GraficoHistoricoLimpo(
                      pontos: indicador.historico,
                      unidade: indicador.unidade,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Metodologia da Métrica',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: esquema.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      indicador.explicacaoMetrica,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: esquema.onSurfaceVariant,
                      ),
                    ),
                    Divider(height: 24, color: esquema.outlineVariant),
                    Text(
                      'Leituras Mensais Registradas',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: esquema.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...indicador.historico.map(
                      (ponto) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mês de referência: ${ponto.rotuloMes}/2026',
                              style: TextStyle(
                                fontSize: 13.5,
                                color: esquema.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '${ponto.valor.toStringAsFixed(1)} ${indicador.unidade}',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: esquema.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}