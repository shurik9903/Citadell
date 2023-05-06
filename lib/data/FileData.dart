//Класс для хранения загруженного файла
import 'dart:convert';

class FileData {
  FileData({this.msg, this.name, this.bytes, this.id});

  final String? msg;
  final String? name;
  final List<int>? bytes;
  final int? id;

  factory FileData.fromJson(Map<String, dynamic> data) {
    final msg = data['Msg'] as String?;
    final name = data['file_name'] as String?;
    final bytes = data['file_byte'] as List<int>?;
    final id = data['file_id'] as int?;
    return FileData(msg: msg, name: name, bytes: bytes, id: id);
  }
}

class DocData {
  DocData({this.msg, this.rowNumber, this.rows, this.title});

  final String? msg;
  final int? rowNumber;
  final Map<String, dynamic>? rows;
  final List<String>? title;

  factory DocData.fromJson(Map<String, dynamic> data) {
    final msg = data['Msg'] as String?;
    final docData = jsonDecode(data['Data']) as Map<String, dynamic>?;

    final rowNumber = docData?["RowNumber"] as String?;
    final rows = jsonDecode(docData?["Rows"]) as Map<String, dynamic>?;
    final title =
        (jsonDecode(docData?["Title"]) as List<dynamic>?)?.cast<String>();

    return DocData(
        msg: msg,
        rowNumber: int.parse(rowNumber ?? "0"),
        rows: rows,
        title: title);
  }
}
