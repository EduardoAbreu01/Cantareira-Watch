class OcorrenciaCidada {
  final String id;
  final String tipoProblema;
  final String regiao;
  final String descricao;
  final DateTime dataRegistro;

  const OcorrenciaCidada({
    required this.id,
    required this.tipoProblema,
    required this.regiao,
    required this.descricao,
    required this.dataRegistro,
  });
}