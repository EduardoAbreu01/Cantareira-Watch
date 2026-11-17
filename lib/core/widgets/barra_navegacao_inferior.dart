import 'package:flutter/material.dart';
import '../tema/tema_aplicativo.dart';

class ItemAbaNavegacao {
  final String rotulo;
  final String dicaAcessibilidade;
  final IconData icone;
  final IconData iconeSelecionado;
  final int quantidadeNotificacoes;

  const ItemAbaNavegacao({
    required this.rotulo,
    required this.dicaAcessibilidade,
    required this.icone,
    required this.iconeSelecionado,
    this.quantidadeNotificacoes = 0,
  });
}

class BarraNavegacaoInferior extends StatelessWidget {
  final int indiceAtual;
  final List<ItemAbaNavegacao> itens;
  final ValueChanged<int> aoSelecionarDestino;

  const BarraNavegacaoInferior({
    super.key,
    required this.indiceAtual,
    required this.itens,
    required this.aoSelecionarDestino,
  });

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final ehEscuro = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: esquema.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: esquema.outlineVariant),
        boxShadow: ehEscuro
            ? []
            : [
                BoxShadow(
                  color: TemaAplicativo.azulPrimario.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: itens.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final selecionado = idx == indiceAtual;
          final corIconeSelecionado =
              ehEscuro ? TemaAplicativo.fundoEscuro : Colors.white;

          Widget iconeWidget = Icon(
            selecionado ? item.iconeSelecionado : item.icone,
            size: 22,
            color: selecionado ? corIconeSelecionado : esquema.onSurfaceVariant,
          );

          if (item.quantidadeNotificacoes > 0) {
            iconeWidget = Badge.count(
              count: item.quantidadeNotificacoes,
              backgroundColor: TemaAplicativo.vermelhoPerigo,
              child: iconeWidget,
            );
          }

          return Semantics(
            button: true,
            selected: selecionado,
            label: item.rotulo,
            hint: item.dicaAcessibilidade,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => aoSelecionarDestino(idx),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: selecionado ? 14 : 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: selecionado ? esquema.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    iconeWidget,
                    if (selecionado) ...[
                      const SizedBox(width: 7),
                      Text(
                        item.rotulo,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: corIconeSelecionado,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}