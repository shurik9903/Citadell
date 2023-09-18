class SpellingWordData {
  SpellingWordData({
    required this.id,
    required this.simpleID,
    required this.word,
    required this.description,
  });

  final int id;
  final int simpleID;
  final String word;
  final String description;

  factory SpellingWordData.fromJson(Map<String, dynamic> data) {
    final id = data['id'];
    final simpleID = data['simple_id'];
    final word = data['word'];
    final description = data['description'] ?? '';
    return SpellingWordData(
      id: id,
      simpleID: simpleID,
      word: word,
      description: description,
    );
  }
}
