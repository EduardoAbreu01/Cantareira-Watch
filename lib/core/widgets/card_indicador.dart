import 'package:flutter/material.dart';
import '../../dados/modelos/indicador_territorial.dart';
import '../tema/tema_aplicativo.dart';

class CardIndicador extends StatelessWidget {
  final IndicadorTerritorial indicador;
  final VoidCallback? aoTocar;

  const CardIndicador({
    super.key,
    required this.indicador,
    this.aoTocar,
  });

  IconData _iconeCategoria() {
    switch (indicador.categoria) {
      case CategoriaDashboard.recursosHidricos:
        return Icons.water_drop_rounded;
      case CategoriaDashboard.climaLocal:
        return Icons.cloud_outlined;
      case CategoriaDashboard.servicosSociais:
        return Icons.hub_outlined;
    }
  }

  double _proporcaoBarra() {
    if (indicador.unidade == '%') {
      return (indicador.valorAtual / 100).clamp(0.05, 1.0);
    }
    if (indicador.historico.isEmpty) return 0.5;
    final maxHist = indicador.historico
        .map((p) => p.valor)
        .reduce((a, b) => a > b ? a : b);
    if (maxHist <= 0) return 0.5;
    return (indicador.valorAtual / (maxHist * 1.15)).clamp(0.08, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final corTendencia = indicador.tendenciaPositiva
        ? TemaAplicativo.verdeSucesso
        : TemaAplicativo.vermelhoPerigo;
    final iconeTendencia = indicador.tendenciaPositiva
        ? Icons.north_east_rounded
        : Icons.south_east_rounded;
    final sinal = indicador.tendenciaPositiva ? '+' : '';

    return Semantics(
      button: aoTocar != null,
      label: '${indicador.titulo}: ${indicador.valorAtual} ${indicador.unidade}',
      hint: 'Toque para ver histórico e projeção detalhada',
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: aoTocar,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: esquema.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _iconeCategoria(),
                        size: 18,
                        color: esquema.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            indicador.titulo,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: esquema.onSurface,
                            ),
                          ),
                          Text(
                            indicador.subtitulo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: esquema.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: corTendencia.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(iconeTendencia, size: 14, color: corTendencia),
                          const SizedBox(width: 3),
                          Text(
                            '$sinal${indicador.variacaoPercentual.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: corTendencia,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      indicador.valorAtual.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        color: esquema.onSurface,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      indicador.unidade,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: esquema.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    if (aoTocar != null)
                      Row(
                        children: [
                          Text(
                            'Detalhes',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: esquema.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 15,
                            color: esquema.primary,
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _proporcaoBarra(),
                    minHeight: 7,
                    backgroundColor: esquema.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      indicador.tendenciaPositiva
                          ? esquema.primary
                          : TemaAplicativo.ambarAlerta,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}