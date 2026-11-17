enum NivelSeveridade { atencao, critico, informativo }

class AlertaPreditivo {
  final String id;
  final String titulo;
  final String regiaoAfetada;
  final NivelSeveridade severidade;
  final String justificativaEvidencia;
  final int nivelConfiancaPercentual;
  final String limitacoesModelo;
  final String condicaoNaoConfiavel;
  final String recomendacaoHumana;
  final DateTime dataGeracao;

  const AlertaPreditivo({
    required this.id,
    required this.titulo,
    required this.regiaoAfetada,
    required this.severidade,
    required this.justificativaEvidencia,
    required this.nivelConfiancaPercentual,
    required this.limitacoesModelo,
    required this.condicaoNaoConfiavel,
    required this.recomendacaoHumana,
    required this.dataGeracao,
  });
}