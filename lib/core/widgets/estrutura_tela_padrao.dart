import 'package:flutter/material.dart';
import '../tema/tema_aplicativo.dart';

class EstruturaTelaPadrao extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final Widget corpo;
  final Widget? barraNavegacaoInferior;
  final List<Widget>? acoes;

  const EstruturaTelaPadrao({
    super.key,
    required this.titulo,
    this.subtitulo,
    required this.corpo,
    this.barraNavegacaoInferior,
    this.acoes,
  });

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: esquema.onSurface,
              ),
            ),
            if (subtitulo != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: TemaAplicativo.verdeSucesso,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    subtitulo!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: esquema.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: acoes != null
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(children: acoes!),
                ),
              ]
            : null,
      ),
      body: SafeArea(child: corpo),
      bottomNavigationBar: barraNavegacaoInferior,
    );
  }
}