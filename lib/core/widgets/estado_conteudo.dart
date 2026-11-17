import 'package:flutter/material.dart';
import '../tema/tema_aplicativo.dart';

class EstadoConteudo extends StatelessWidget {
  final bool estaCarregando;
  final String? mensagemErro;
  final bool estaVazio;
  final String mensagemVazio;
  final VoidCallback? aoTentarNovamente;
  final Widget filho;

  const EstadoConteudo({
    super.key,
    required this.estaCarregando,
    this.mensagemErro,
    required this.estaVazio,
    this.mensagemVazio = 'Nenhum registro encontrado.',
    this.aoTentarNovamente,
    required this.filho,
  });

  @override
  Widget build(BuildContext context) {
    if (estaCarregando) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (mensagemErro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: TemaAplicativo.vermelhoPerigo,
              ),
              const SizedBox(height: 12),
              Text(
                mensagemErro!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: TemaAplicativo.textoPrincipal,
                ),
              ),
              if (aoTentarNovamente != null) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: aoTentarNovamente,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (estaVazio) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.inbox_outlined,
                size: 48,
                color: TemaAplicativo.textoSecundario,
              ),
              const SizedBox(height: 12),
              Text(
                mensagemVazio,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: TemaAplicativo.textoSecundario,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return filho;
  }
}