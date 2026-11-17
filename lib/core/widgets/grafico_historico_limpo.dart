import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../dados/modelos/indicador_territorial.dart';

class GraficoHistoricoLimpo extends StatelessWidget {
  final List<PontoHistorico> pontos;
  final String unidade;
  final Color? corLinha;

  const GraficoHistoricoLimpo({
    super.key,
    required this.pontos,
    required this.unidade,
    this.corLinha,
  });

  @override
  Widget build(BuildContext context) {
    if (pontos.isEmpty) return const SizedBox.shrink();

    final esquema = Theme.of(context).colorScheme;
    final corAtiva = corLinha ?? esquema.primary;

    final spots = pontos
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.valor))
        .toList();

    final valores = pontos.map((p) => p.valor).toList();
    final minY = (valores.reduce((a, b) => a < b ? a : b) * 0.88).floorToDouble();
    final maxY = (valores.reduce((a, b) => a > b ? a : b) * 1.08).ceilToDouble();

    return SizedBox(
      height: 190,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: esquema.outlineVariant,
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (valor, _) => Text(
                  valor.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 11,
                    color: esquema.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (valor, _) {
                  final idx = valor.toInt();
                  if (idx < 0 || idx >= pontos.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      pontos[idx].rotuloMes,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: esquema.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => esquema.onSurface,
              getTooltipItems: (tocados) => tocados.map((item) {
                final ponto = pontos[item.x.toInt()];
                return LineTooltipItem(
                  '${ponto.rotuloMes}\n${ponto.valor.toStringAsFixed(1)} $unidade',
                  TextStyle(
                    color: esquema.surface,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.32,
              color: corAtiva,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 3.5,
                  color: esquema.surfaceContainerLowest,
                  strokeWidth: 2.2,
                  strokeColor: corAtiva,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    corAtiva.withValues(alpha: 0.20),
                    corAtiva.withValues(alpha: 0.0),
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