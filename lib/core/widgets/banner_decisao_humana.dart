import 'package:flutter/material.dart';
import '../tema/tema_aplicativo.dart';

class BannerDecisaoHumana extends StatelessWidget {
  const BannerDecisaoHumana({super.key});

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Aviso de governança: decisão final humana',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: esquema.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: TemaAplicativo.ambarAlerta.withValues(alpha: 0.50),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: TemaAplicativo.ambarAlerta.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: TemaAplicativo.ambarAlerta,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Apoio à decisão: sem automação crítica. A decisão final é sempre humana.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: esquema.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}