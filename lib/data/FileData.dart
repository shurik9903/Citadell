//Класс для хранения загруженного файла
import 'dart:convert';

class FileData {
  FileData({this.name, this.bytes, this.id});

  final String? name;
  final List<int>? bytes;
  final int? id;

  factory FileData.fromJson(Map<String, dynamic> data) {
    final name = data['file_name'] as String?;
    final bytes = data['file_byte'] as List<int>?;
    final id = data['file_id'] as int?;
    return FileData(name: name, bytes: bytes, id: id);
  }
}

class DocData {
  DocData({this.rowNumber, this.rows, this.title, this.type});

  final int? rowNumber;
  final Map<String, dynamic>? rows;
  final Map<String, dynamic>? type;
  final List<String>? title;

  factory DocData.fromJson(Map<String, dynamic> data) {
    final docData = jsonDecode(data['Data']) as Map<String, dynamic>?;

    final rowNumber = docData?["rowNumber"];
    final rows = docData?["rows"];
    final title = (docData?["title"] as List<dynamic>).cast<String>();
    final type = docData?["type"];

    return DocData(
        rowNumber: rowNumber ?? 0, rows: rows, title: title, type: type);
  }
}
