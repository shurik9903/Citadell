//Класс для хранения загруженного файла
import 'dart:convert';

class FileData {
  FileData({required this.name, required this.bytes, required this.id});

  final String name;
  final List<int>? bytes;
  final int id;

  factory FileData.fromJson(Map<String, dynamic> data) {
    final name = data['file_name'];
    final bytes = data['file_byte'];
    final id = data['file_id'];
    return FileData(
      name: name,
      bytes: bytes,
      id: id,
    );
  }
}

class DocData {
  DocData({
    required this.rowNumber,
    required this.rows,
    required this.title,
    required this.titleTypes,
  });

  final int rowNumber;
  final Map<String, dynamic> rows;
  final List<String> title;
  final List<String> titleTypes;

  factory DocData.fromJson(Map<String, dynamic> data) {
    final Map<String, dynamic> docData = jsonDecode(data['Data']);

    final rowNumber = docData["rowNumber"];
    final rows = docData["rows"];
    final title = docData["title"].cast<String>();
    final titleTypes = docData["titleTypes"].cast<String>();

    return DocData(
      rowNumber: rowNumber,
      rows: rows,
      title: title,
      titleTypes: titleTypes,
    );
  }
}

class AnalysisWord {
  final int? id;
  final bool isWord;
  final String word;

  AnalysisWord({this.id, required this.isWord, required this.word});

  factory AnalysisWord.fromJson(Map<String, dynamic> data) {
    final id = data['id'];
    final isWord = data['isWord'];
    final word = data['word'];

    return AnalysisWord(id: id, isWord: isWord, word: word);
  }
}
