import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/tema/tema_aplicativo.dart';
import '../../../core/widgets/banner_decisao_humana.dart';
import '../../../core/widgets/card_alerta.dart';
import '../../../core/widgets/card_indicador.dart';
import '../../../core/widgets/estado_conteudo.dart';
import '../../../estado/provedor_territorial.dart';
import '../../../rotas/rotas_aplicativo.dart';

class AbaVisaoGeral extends StatelessWidget {
  const AbaVisaoGeral({super.key});

  String _formatarMilhar(int numero) {
    final texto = numero.toString();
    return texto.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final provedor = context.watch<ProvedorTerritorial>();
    final esquema = Theme.of(context).colorScheme;

    return EstadoConteudo(
      estaCarregando: provedor.estaCarregando,
      mensagemErro: provedor.mensagemErro,
      estaVazio: provedor.indicadores.isEmpty,
      aoTentarNovamente: provedor.inicializar,
      filho: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          const BannerDecisaoHumana(),
          Container(
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              gradient: TemaAplicativo.gradienteHeroHidro,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: TemaAplicativo.azulPrimario.withValues(alpha: 0.22),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -18,
                  top: -18,
                  child: Icon(
                    Icons.water_drop_rounded,
                    size: 140,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.groups_rounded,
                              color: TemaAplicativo.cianoBrilho,
                              size: 15,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'IMPACTO SOCIAL & PREVENÇÃO',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _formatarMilhar(provedor.familiasProtegidasEstimadas),
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Famílias protegidas por monitoramento antecipado na RMSP',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _miniMetricaHero(
                              valor: '${provedor.diasAntecipacaoAlerta} dias',
                              rotulo: 'Antecipação média',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _miniMetricaHero(
                              valor: '${provedor.ocorrencias.length} relatos',
                              rotulo: 'Participação cidadã',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Indicador Principal do Território',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: esquema.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          CardIndicador(
            indicador: provedor.indicadores.first,
            aoTocar: () {
              Navigator.pushNamed(
                context,
                RotasAplicativo.detalheIndicador,
                arguments: provedor.indicadores.first,
              );
            },
          ),
          if (provedor.alertasAtivos.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Alerta Prioritário em Destaque',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: esquema.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            CardAlerta(
              alerta: provedor.alertasAtivos.first,
              aoTocar: () {
                Navigator.pushNamed(
                  context,
                  RotasAplicativo.detalheAlerta,
                  arguments: provedor.alertasAtivos.first,
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _miniMetricaHero({required String valor, required String rotulo}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            valor,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            rotulo,
            style: const TextStyle(fontSize: 11.5, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}