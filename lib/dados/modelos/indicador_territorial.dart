enum CategoriaDashboard { recursosHidricos, climaLocal, servicosSociais }

class PontoHistorico {
  final String rotuloMes;
  final double valor;

  const PontoHistorico({required this.rotuloMes, required this.valor});
}

class IndicadorTerritorial {
  final String id;
  final String titulo;
  final String subtitulo;
  final String unidade;
  final double valorAtual;
  final double variacaoPercentual;
  final CategoriaDashboard categoria;
  final List<PontoHistorico> historico;
  final String explicacaoMetrica;

  const IndicadorTerritorial({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.unidade,
    required this.valorAtual,
    required this.variacaoPercentual,
    required this.categoria,
    required this.historico,
    required this.explicacaoMetrica,
  });

  bool get tendenciaPositiva => variacaoPercentual >= 0;
}