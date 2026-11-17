import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/tema/tema_aplicativo.dart';
import '../../estado/provedor_territorial.dart';

class TelaConsentimento extends StatefulWidget {
  const TelaConsentimento({super.key});

  @override
  State<TelaConsentimento> createState() => _TelaConsentimentoState();
}

class _TelaConsentimentoState extends State<TelaConsentimento> {
  bool _concordouTermos = false;

  Future<void> _confirmarEContinuar() async {
    await context.read<ProvedorTerritorial>().aceitarConsentimento();
    if (!mounted) return;
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final ehEscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: esquema.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  size: 36,
                  color: esquema.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Privacidade e Uso Responsável',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: esquema.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Antes de acessar o painel de inteligência hídrica do Sistema Cantareira, confira nossos compromissos:',
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.4,
                  color: esquema.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _itemCompromisso(
                        context: context,
                        icone: Icons.visibility_off_outlined,
                        titulo: 'Dados 100% Anonimizados',
                        descricao:
                            'Não coletamos nome, CPF, telefone ou rastreamento GPS contínuo. Apenas a região informada nas ocorrências é salva.',
                      ),
                      Divider(height: 24, color: esquema.outlineVariant),
                      _itemCompromisso(
                        context: context,
                        icone: Icons.verified_user_outlined,
                        titulo: 'Supervisão Humana Obrigatória',
                        descricao:
                            'Os alertas preditivos servem exclusivamente como apoio técnico aos gestores e cidadãos, sem ações automáticas.',
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Semantics(
                label: 'Caixa de seleção para aceitar os termos de privacidade',
                child: CheckboxListTile(
                  value: _concordouTermos,
                  onChanged: (valor) {
                    setState(() => _concordouTermos = valor ?? false);
                  },
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: esquema.primary,
                  checkColor:
                      ehEscuro ? TemaAplicativo.fundoEscuro : Colors.white,
                  title: Text(
                    'Li e concordo com o tratamento anonimizado dos dados e com os termos de uso.',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: esquema.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _concordouTermos ? _confirmarEContinuar : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: esquema.primary,
                    foregroundColor:
                        ehEscuro ? TemaAplicativo.fundoEscuro : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Concordar e Acessar Painel',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemCompromisso({
    required BuildContext context,
    required IconData icone,
    required String titulo,
    required String descricao,
  }) {
    final esquema = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icone, color: esquema.primary, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: esquema.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                descricao,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: esquema.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}