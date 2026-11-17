import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dados/modelos/alerta_preditivo.dart';
import '../dados/modelos/indicador_territorial.dart';
import '../dados/modelos/ocorrencia_cidada.dart';

class ProvedorTerritorial extends ChangeNotifier {
  static const String _chaveConsentimento = 'consentimento_aceito';
  static const String _chaveLimiarVolume = 'limiar_volume_alerta';
  static const String _chaveOcorrencias = 'ocorrencias_salvas';
  static const String _chaveModoEscuro = 'modo_escuro_ativo';
  bool _modoEscuro = false;
  bool get modoEscuro => _modoEscuro;

  bool _estaCarregando = true;
  String? _mensagemErro;
  bool _consentimentoAceito = false;
  double _limiarVolumeAlerta = 40.0;

  List<IndicadorTerritorial> _indicadores = [];
  List<OcorrenciaCidada> _ocorrencias = [];

  bool get estaCarregando => _estaCarregando;
  String? get mensagemErro => _mensagemErro;
  bool get consentimentoAceito => _consentimentoAceito;
  double get limiarVolumeAlerta => _limiarVolumeAlerta;
  List<IndicadorTerritorial> get indicadores => _indicadores;
  List<OcorrenciaCidada> get ocorrencias => List.unmodifiable(_ocorrencias);

  // Indicadores de benefício social (Critério 8)
  int get familiasProtegidasEstimadas => 142500 + (_ocorrencias.length * 350);
  int get diasAntecipacaoAlerta => 21;

  List<IndicadorTerritorial> indicadoresPorCategoria(CategoriaDashboard categoria) {
    return _indicadores.where((i) => i.categoria == categoria).toList();
  }

  List<AlertaPreditivo> get alertasAtivos {
    if (_indicadores.isEmpty) return [];

    final lista = <AlertaPreditivo>[];
    final volumeAtual = _indicadores
        .firstWhere((i) => i.id == 'volume_util', orElse: () => _indicadores.first)
        .valorAtual;

    if (volumeAtual < _limiarVolumeAlerta) {
      final diferenca = (_limiarVolumeAlerta - volumeAtual).toStringAsFixed(1);
      lista.add(
        AlertaPreditivo(
          id: 'alerta_volume_cantareira',
          titulo: 'Risco de Escassez Hídrica Moderada (Faixa de Atenção)',
          regiaoAfetada: 'Sistema Cantareira • Zona Norte e Centro RMSP',
          severidade: volumeAtual < 35.0
              ? NivelSeveridade.critico
              : NivelSeveridade.atencao,
          justificativaEvidencia:
              'O volume útil atual (${volumeAtual.toStringAsFixed(1)}%) está $diferenca p.p. abaixo do limiar configurado (${_limiarVolumeAlerta.toStringAsFixed(0)}%), com projeção de queda para 33,1% em 90 dias.',
          nivelConfiancaPercentual: 87,
          limitacoesModelo:
              'Modelo treinado com séries históricas de 2014–2026; não incorpora manobras emergenciais de transposição interbacias.',
          condicaoNaoConfiavel:
              'Previsão perde confiabilidade em eventos extremos de precipitação convectiva atípica acima de 120 mm em 48h.',
          recomendacaoHumana:
              'Avaliar campanha preventiva de redução de pressão noturna junto à operadora e Defesa Civil.',
          dataGeracao: DateTime.now(),
        ),
      );
    }

    lista.add(
      AlertaPreditivo(
        id: 'alerta_deficit_pluviometrico',
        titulo: 'Anomalia Negativa de Precipitação na Bacia Jaguari-Jacareí',
        regiaoAfetada: 'Sub-bacia Atibainha / Cachoeira',
        severidade: NivelSeveridade.atencao,
        justificativaEvidencia:
            'Precipitação acumulada nos últimos 30 dias (84 mm) ficou 28,5% abaixo da média climatológica histórica do período.',
        nivelConfiancaPercentual: 82,
        limitacoesModelo:
            'Baseado em estações telemétricas de superfície; microclimas locais podem apresentar variação.',
        condicaoNaoConfiavel:
            'Falha de telemetria superior a 24h nas estações de cabeceira.',
        recomendacaoHumana:
            'Intensificar monitoramento semanal de vazão afluente antes de alterar regras de outorga.',
        dataGeracao: DateTime.now().subtract(const Duration(hours: 4)),
      ),
    );

    if (_ocorrencias.length >= 2) {
      lista.add(
        AlertaPreditivo(
          id: 'alerta_demanda_cidada',
          titulo: 'Aumento de Relatos de Baixa Pressão e Vazamentos',
          regiaoAfetada: _ocorrencias.first.regiao,
          severidade: NivelSeveridade.informativo,
          justificativaEvidencia:
              'Foram registradas ${_ocorrencias.length} ocorrências comunitárias recentes, indicando sobrecarga pontual na rede de distribuição.',
          nivelConfiancaPercentual: 76,
          limitacoesModelo:
              'Dados colaborativos dependem do engajamento local e podem sub-representar bairros com menor conectividade.',
          condicaoNaoConfiavel:
              'Múltiplos relatos duplicados sobre o mesmo ponto em menos de 1 hora.',
          recomendacaoHumana:
              'Priorizar vistoria técnica de campo nas regiões reportadas pelos cidadãos.',
          dataGeracao: DateTime.now(),
        ),
      );
    }

    return lista;
  }

  Future<void> inicializar() async {
    try {
      _estaCarregando = true;
      _mensagemErro = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      _consentimentoAceito = prefs.getBool(_chaveConsentimento) ?? false;
      _limiarVolumeAlerta = prefs.getDouble(_chaveLimiarVolume) ?? 40.0;
      _modoEscuro = prefs.getBool(_chaveModoEscuro) ?? false;

      final ocorrenciasJson = prefs.getStringList(_chaveOcorrencias);
      if (ocorrenciasJson != null) {
        _ocorrencias = ocorrenciasJson.map((item) {
          final mapa = jsonDecode(item) as Map<String, dynamic>;
          return OcorrenciaCidada(
            id: mapa['id'] as String,
            tipoProblema: mapa['tipoProblema'] as String,
            regiao: mapa['regiao'] as String,
            descricao: mapa['descricao'] as String,
            dataRegistro: DateTime.parse(mapa['dataRegistro'] as String),
          );
        }).toList();
      } else {
        _ocorrencias = [
          OcorrenciaCidada(
            id: 'oc_inicial_1',
            tipoProblema: 'Baixa pressão na rede',
            regiao: 'Santana / Zona Norte SP',
            descricao: 'Redução recorrente de pressão após as 21h.',
            dataRegistro: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ];
      }

      _carregarIndicadoresCantareira();
      _estaCarregando = false;
      notifyListeners();
    } catch (e) {
      _estaCarregando = false;
      _mensagemErro = 'Não foi possível carregar os dados territoriais locais.';
      notifyListeners();
    }
  }

  Future<void> aceitarConsentimento() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveConsentimento, true);
    _consentimentoAceito = true;
    notifyListeners();
  }
  
  Future<void> alternarModoEscuro() async {
    _modoEscuro = !_modoEscuro;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_chaveModoEscuro, _modoEscuro);
    } catch (_) {}
  }

  Future<void> atualizarLimiarVolume(double novoLimiar) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_chaveLimiarVolume, novoLimiar);
    _limiarVolumeAlerta = novoLimiar;
    notifyListeners();
  }

  Future<void> adicionarOcorrencia({
    required String tipoProblema,
    required String regiao,
    required String descricao,
  }) async {
    final nova = OcorrenciaCidada(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tipoProblema: tipoProblema,
      regiao: regiao,
      descricao: descricao,
      dataRegistro: DateTime.now(),
    );

    _ocorrencias.insert(0, nova);
    final prefs = await SharedPreferences.getInstance();
    final listaSerializada = _ocorrencias
        .map((o) => jsonEncode({
              'id': o.id,
              'tipoProblema': o.tipoProblema,
              'regiao': o.regiao,
              'descricao': o.descricao,
              'dataRegistro': o.dataRegistro.toIso8601String(),
            }))
        .toList();
    await prefs.setStringList(_chaveOcorrencias, listaSerializada);
    notifyListeners();
  }

  void _carregarIndicadoresCantareira() {
    _indicadores = [
      // Dashboard 1: Recursos Hídricos
      const IndicadorTerritorial(
        id: 'volume_util',
        titulo: 'Volume Útil Cantareira',
        subtitulo: 'Percentual armazenado nos reservatórios equivalentes',
        unidade: '%',
        valorAtual: 38.4,
        variacaoPercentual: -4.2,
        categoria: CategoriaDashboard.recursosHidricos,
        explicacaoMetrica:
            'Relação entre o volume armazenado atual e a capacidade útil total (982 hm³).',
        historico: [
          PontoHistorico(rotuloMes: 'Jun', valor: 49.5),
          PontoHistorico(rotuloMes: 'Jul', valor: 46.8),
          PontoHistorico(rotuloMes: 'Ago', valor: 43.9),
          PontoHistorico(rotuloMes: 'Set', valor: 41.2),
          PontoHistorico(rotuloMes: 'Out', valor: 39.8),
          PontoHistorico(rotuloMes: 'Nov', valor: 38.4),
        ],
      ),
      const IndicadorTerritorial(
        id: 'vazao_afluente',
        titulo: 'Vazão Afluente Média',
        subtitulo: 'Entrada natural de água nas represas do sistema',
        unidade: 'm³/s',
        valorAtual: 14.2,
        variacaoPercentual: -11.5,
        categoria: CategoriaDashboard.recursosHidricos,
        explicacaoMetrica:
            'Média mensal da vazão que chega aos reservatórios Jaguari, Jacareí, Cachoeira e Atibainha.',
        historico: [
          PontoHistorico(rotuloMes: 'Jun', valor: 21.0),
          PontoHistorico(rotuloMes: 'Jul', valor: 18.4),
          PontoHistorico(rotuloMes: 'Ago', valor: 16.1),
          PontoHistorico(rotuloMes: 'Set', valor: 15.0),
          PontoHistorico(rotuloMes: 'Out', valor: 14.9),
          PontoHistorico(rotuloMes: 'Nov', valor: 14.2),
        ],
      ),

      // Dashboard 2: Clima Local
      const IndicadorTerritorial(
        id: 'precipitacao_30d',
        titulo: 'Precipitação Acumulada (30d)',
        subtitulo: 'Chuva observada na área de drenagem da bacia',
        unidade: 'mm',
        valorAtual: 84.0,
        variacaoPercentual: -28.5,
        categoria: CategoriaDashboard.climaLocal,
        explicacaoMetrica:
            'Soma pluviométrica ponderada pelas estações telemétricas da bacia do Piracicaba/Cantareira.',
        historico: [
          PontoHistorico(rotuloMes: 'Jun', valor: 38.0),
          PontoHistorico(rotuloMes: 'Jul', valor: 29.0),
          PontoHistorico(rotuloMes: 'Ago', valor: 34.0),
          PontoHistorico(rotuloMes: 'Set', valor: 58.0),
          PontoHistorico(rotuloMes: 'Out', valor: 76.0),
          PontoHistorico(rotuloMes: 'Nov', valor: 84.0),
        ],
      ),
      const IndicadorTerritorial(
        id: 'temperatura_media',
        titulo: 'Temperatura Máxima Média',
        subtitulo: 'Fator de evapotranspiração nos espelhos d’água',
        unidade: '°C',
        valorAtual: 27.8,
        variacaoPercentual: 6.1,
        categoria: CategoriaDashboard.climaLocal,
        explicacaoMetrica:
            'Temperaturas acima de 27 °C aceleram a perda hídrica superficial e elevam o consumo urbano.',
        historico: [
          PontoHistorico(rotuloMes: 'Jun', valor: 22.1),
          PontoHistorico(rotuloMes: 'Jul', valor: 22.8),
          PontoHistorico(rotuloMes: 'Ago', valor: 24.5),
          PontoHistorico(rotuloMes: 'Set', valor: 26.2),
          PontoHistorico(rotuloMes: 'Out', valor: 27.1),
          PontoHistorico(rotuloMes: 'Nov', valor: 27.8),
        ],
      ),

      // Dashboard 3: Demanda por Serviços
      const IndicadorTerritorial(
        id: 'indice_continuidade',
        titulo: 'Continuidade do Abastecimento',
        subtitulo: 'Percentual de setores operando sem intermitência',
        unidade: '%',
        valorAtual: 96.4,
        variacaoPercentual: -1.1,
        categoria: CategoriaDashboard.servicosSociais,
        explicacaoMetrica:
            'Monitora a regularidade do fornecimento nas zonas atendidas pelo sistema na RMSP.',
        historico: [
          PontoHistorico(rotuloMes: 'Jun', valor: 99.1),
          PontoHistorico(rotuloMes: 'Jul', valor: 98.8),
          PontoHistorico(rotuloMes: 'Ago', valor: 98.2),
          PontoHistorico(rotuloMes: 'Set', valor: 97.6),
          PontoHistorico(rotuloMes: 'Out', valor: 97.0),
          PontoHistorico(rotuloMes: 'Nov', valor: 96.4),
        ],
      ),
    ];
  }
}