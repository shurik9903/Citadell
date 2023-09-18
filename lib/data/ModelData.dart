class ModelData {
  ModelData(
      {required this.id,
      required this.name,
      required this.score,
      required this.active});

  final int id;
  final double score;
  final bool active;
  final String name;

  factory ModelData.fromJson(Map<String, dynamic> data) {
    final score = data['score'];
    final active = data['Active'];
    final id = data['ID'];
    final name = data['NameModel'];
    return ModelData(score: score, active: active, id: id, name: name);
  }
}
