import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/tema/tema_aplicativo.dart';
import '../../core/widgets/banner_decisao_humana.dart';
import '../../estado/provedor_territorial.dart';

class AbaOcorrencias extends StatefulWidget {
  const AbaOcorrencias({super.key});

  @override
  State<AbaOcorrencias> createState() => _AbaOcorrenciasState();
}

class _AbaOcorrenciasState extends State<AbaOcorrencias> {
  final _chaveFormulario = GlobalKey<FormState>();
  final _controladorRegiao = TextEditingController();
  final _controladorDescricao = TextEditingController();

  String _tipoSelecionado = 'Baixa pressão na rede';
  static const List<String> _tiposOcorrencia = [
    'Baixa pressão na rede',
    'Falta de água prolongada',
    'Vazamento na via pública',
    'Alteração na turbidez da água',
  ];

  @override
  void dispose() {
    _controladorRegiao.dispose();
    _controladorDescricao.dispose();
    super.dispose();
  }

  Future<void> _enviarOcorrencia() async {
    if (!_chaveFormulario.currentState!.validate()) return;

    await context.read<ProvedorTerritorial>().adicionarOcorrencia(
          tipoProblema: _tipoSelecionado,
          regiao: _controladorRegiao.text.trim(),
          descricao: _controladorDescricao.text.trim(),
        );

    _controladorRegiao.clear();
    _controladorDescricao.clear();

    if (!mounted) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ocorrência registrada localmente com sucesso!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provedor = context.watch<ProvedorTerritorial>();
    final esquema = Theme.of(context).colorScheme;
    final ehEscuro = Theme.of(context).brightness == Brightness.dark;
    final corTextoBotao = ehEscuro ? TemaAplicativo.fundoEscuro : Colors.white;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
      children: [
        const BannerDecisaoHumana(),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Limiar de Alerta do Volume Útil',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: esquema.onSurface,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: esquema.primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${provedor.limiarVolumeAlerta.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: esquema.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Gera alerta automático quando o volume do Cantareira ficar abaixo deste patamar (salvo offline).',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: esquema.onSurfaceVariant,
                  ),
                ),
                Slider(
                  value: provedor.limiarVolumeAlerta,
                  min: 25,
                  max: 60,
                  divisions: 35,
                  activeColor: esquema.primary,
                  label: '${provedor.limiarVolumeAlerta.toStringAsFixed(0)}%',
                  onChanged: (novoValor) {
                    provedor.atualizarLimiarVolume(novoValor);
                  },
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _chaveFormulario,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registrar Ocorrência Territorial',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: esquema.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Relato anônimo para apoio ao mapeamento de demanda.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: esquema.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _tipoSelecionado,
                    dropdownColor: esquema.surfaceContainerLowest,
                    style: TextStyle(color: esquema.onSurface, fontSize: 14),
                    decoration: const InputDecoration(
                      labelText: 'Tipo de ocorrência',
                    ),
                    items: _tiposOcorrencia
                        .map(
                          (tipo) => DropdownMenuItem(
                            value: tipo,
                            child: Text(tipo),
                          ),
                        )
                        .toList(),
                    onChanged: (valor) {
                      if (valor != null) {
                        setState(() => _tipoSelecionado = valor);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _controladorRegiao,
                    style: TextStyle(color: esquema.onSurface),
                    decoration: const InputDecoration(
                      labelText: 'Bairro ou Região (sem endereço exato)',
                      hintText: 'Ex.: Tucuruvi / Zona Norte',
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().length < 3) {
                        return 'Informe o bairro ou região com pelo menos 3 caracteres.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _controladorDescricao,
                    maxLines: 3,
                    style: TextStyle(color: esquema.onSurface),
                    decoration: const InputDecoration(
                      labelText: 'Descrição observada',
                      hintText: 'Descreva o horário e a situação encontrada...',
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().length < 10) {
                        return 'Detalhe a ocorrência com pelo menos 10 caracteres.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: _enviarOcorrencia,
                      style: FilledButton.styleFrom(
                        backgroundColor: esquema.primary,
                        foregroundColor: corTextoBotao,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text(
                        'Salvar Ocorrência Offline',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Registros Salvos Localmente (${provedor.ocorrencias.length})',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: esquema.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        ...provedor.ocorrencias.map(
          (oc) => Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: esquema.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.water_drop_outlined,
                  color: esquema.primary,
                ),
              ),
              title: Text(
                '${oc.tipoProblema} • ${oc.regiao}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: esquema.onSurface,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  oc.descricao,
                  style: TextStyle(
                    fontSize: 13,
                    color: esquema.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}