import 'package:flutter/material.dart';
import '../../dados/modelos/alerta_preditivo.dart';
import '../tema/tema_aplicativo.dart';

class CardAlerta extends StatelessWidget {
  final AlertaPreditivo alerta;
  final VoidCallback? aoTocar;

  const CardAlerta({
    super.key,
    required this.alerta,
    this.aoTocar,
  });

  Color _corSeveridade() {
    switch (alerta.severidade) {
      case NivelSeveridade.critico:
        return TemaAplicativo.vermelhoPerigo;
      case NivelSeveridade.atencao:
        return TemaAplicativo.ambarAlerta;
      case NivelSeveridade.informativo:
        return TemaAplicativo.cianoSecundario;
    }
  }

  String _rotuloSeveridade() {
    switch (alerta.severidade) {
      case NivelSeveridade.critico:
        return 'CRÍTICO';
      case NivelSeveridade.atencao:
        return 'ATENÇÃO';
      case NivelSeveridade.informativo:
        return 'MONITORAMENTO';
    }
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final cor = _corSeveridade();

    return Semantics(
      button: aoTocar != null,
      label: 'Alerta ${_rotuloSeveridade()}: ${alerta.titulo}',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: aoTocar,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: cor, width: 5),
              ),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: cor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _rotuloSeveridade(),
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: cor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        alerta.regiaoAfetada,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: esquema.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${alerta.nivelConfiancaPercentual}% conf.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: esquema.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  alerta.titulo,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: esquema.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  alerta.justificativaEvidencia,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: esquema.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.psychology_alt_outlined, size: 16, color: cor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Inspecionar evidências, limitações e ação recomendada',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: esquema.primary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: esquema.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}