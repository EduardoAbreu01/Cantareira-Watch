import 'package:flutter/material.dart';
import '../../core/tema/tema_aplicativo.dart';
import '../../core/widgets/banner_decisao_humana.dart';
import '../../dados/modelos/alerta_preditivo.dart';

class TelaDetalheAlerta extends StatelessWidget {
  final AlertaPreditivo alerta;

  const TelaDetalheAlerta({super.key, required this.alerta});

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Transparência do Alerta')),
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
                      alerta.regiaoAfetada,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: esquema.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      alerta.titulo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: esquema.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nível de Confiança Estatística',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: esquema.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '${alerta.nivelConfiancaPercentual}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: esquema.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: alerta.nivelConfiancaPercentual / 100,
                        minHeight: 8,
                        backgroundColor: esquema.surface,
                        color: esquema.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _blocoTransparencia(
              context: context,
              icone: Icons.analytics_outlined,
              titulo: 'Justificativa e Evidência nos Dados',
              conteudo: alerta.justificativaEvidencia,
              corDestaque: esquema.primary,
            ),
            _blocoTransparencia(
              context: context,
              icone: Icons.balance_outlined,
              titulo: 'Limitações e Vieses Conhecidos',
              conteudo: alerta.limitacoesModelo,
              corDestaque: TemaAplicativo.ambarAlerta,
            ),
            _blocoTransparencia(
              context: context,
              icone: Icons.warning_amber_rounded,
              titulo: 'Quando Esta Previsão Não é Confiável',
              conteudo: alerta.condicaoNaoConfiavel,
              corDestaque: TemaAplicativo.vermelhoPerigo,
            ),
            _blocoTransparencia(
              context: context,
              icone: Icons.engineering_outlined,
              titulo: 'Sugestão de Ação para o Gestor Humano',
              conteudo: alerta.recomendacaoHumana,
              corDestaque: TemaAplicativo.verdeSucesso,
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Ciência técnica registrada. Nenhuma ação automática foi executada.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Registrar Ciência Técnica (Sem Automação)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blocoTransparencia({
    required BuildContext context,
    required IconData icone,
    required String titulo,
    required String conteudo,
    required Color corDestaque,
  }) {
    final esquema = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, size: 20, color: corDestaque),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: esquema.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              conteudo,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: esquema.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}