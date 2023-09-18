class SimpleWordData {
  SimpleWordData({
    required this.id,
    required this.typeID,
    required this.word,
  });

  final int id;
  final int typeID;
  final String word;

  factory SimpleWordData.fromJson(Map<String, dynamic> data) {
    final id = data['id'];
    final typeID = data['type_id'];
    final word = data['word'];
    return SimpleWordData(id: id, typeID: typeID, word: word);
  }
}
