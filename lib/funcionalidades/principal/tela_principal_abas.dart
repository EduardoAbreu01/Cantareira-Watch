import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/barra_navegacao_inferior.dart';
import '../../core/widgets/estrutura_tela_padrao.dart';
import '../../estado/provedor_territorial.dart';
import '../../rotas/rotas_aplicativo.dart';
import '../alertas/aba_alertas.dart';
import '../ocorrencias/aba_ocorrencias.dart';
import '../paineis/aba_paineis.dart';
import '../principal/visao_geral/aba_visao_geral.dart';

class TelaPrincipalAbas extends StatefulWidget {
  const TelaPrincipalAbas({super.key});

  @override
  State<TelaPrincipalAbas> createState() => _TelaPrincipalAbasState();
}

class _TelaPrincipalAbasState extends State<TelaPrincipalAbas> {
  int _indiceSelecionado = 0;

  static const List<String> _titulosTelas = [
    'Cantareira Watch',
    'Dashboards Territoriais',
    'Alertas Preditivos',
    'Ocorrências & Limiares',
  ];

  final List<Widget> _abas = const [
    AbaVisaoGeral(),
    AbaPaineis(),
    AbaAlertas(),
    AbaOcorrencias(),
  ];

  @override
  Widget build(BuildContext context) {
    final provedor = context.watch<ProvedorTerritorial>();
    final totalAlertas = provedor.alertasAtivos.length;

    final itensNavegacao = [
      const ItemAbaNavegacao(
        rotulo: 'Visão Geral',
        dicaAcessibilidade: 'Abre o resumo executivo e impacto social',
        icone: Icons.home_outlined,
        iconeSelecionado: Icons.home_rounded,
      ),
      const ItemAbaNavegacao(
        rotulo: 'Dashboards',
        dicaAcessibilidade: 'Abre os gráficos de recursos hídricos, clima e serviços',
        icone: Icons.analytics_outlined,
        iconeSelecionado: Icons.analytics_rounded,
      ),
      ItemAbaNavegacao(
        rotulo: 'Alertas',
        dicaAcessibilidade: 'Abre os alertas preditivos com justificativas e limitações',
        icone: Icons.warning_amber_outlined,
        iconeSelecionado: Icons.warning_amber_rounded,
        quantidadeNotificacoes: totalAlertas,
      ),
      const ItemAbaNavegacao(
        rotulo: 'Registrar',
        dicaAcessibilidade: 'Abre o formulário de ocorrências e configuração de limiares',
        icone: Icons.edit_note_outlined,
        iconeSelecionado: Icons.edit_note_rounded,
      ),
    ];

    return EstruturaTelaPadrao(
      titulo: _titulosTelas[_indiceSelecionado],
      subtitulo: 'Sistema Cantareira • RMSP',
      acoes: [
        Semantics(
          button: true,
          label: provedor.modoEscuro
              ? 'Ativar modo claro'
              : 'Ativar modo escuro',
          child: IconButton(
            tooltip: provedor.modoEscuro ? 'Modo Claro' : 'Modo Escuro',
            icon: Icon(
              provedor.modoEscuro
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: provedor.alternarModoEscuro,
          ),
        ),
        Semantics(
          button: true,
          label: 'Ver termos de privacidade e consentimento',
          child: IconButton(
            tooltip: 'Privacidade e Consentimento',
            icon: const Icon(Icons.shield_outlined),
            onPressed: () {
              Navigator.pushNamed(context, RotasAplicativo.consentimento);
            },
          ),
        ),
      ],
      corpo: IndexedStack(
        index: _indiceSelecionado,
        children: _abas,
      ),
      barraNavegacaoInferior: BarraNavegacaoInferior(
        indiceAtual: _indiceSelecionado,
        itens: itensNavegacao,
        aoSelecionarDestino: (novoIndice) {
          setState(() => _indiceSelecionado = novoIndice);
        },
      ),
    );
  }
}