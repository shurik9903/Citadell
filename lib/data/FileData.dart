//Класс для хранения загруженного файла
import 'dart:convert';

class FileData {
  FileData({this.msg, this.name, this.bytes});

  final String? msg;
  final String? name;
  final List<int>? bytes;

  factory FileData.fromJson(Map<String, dynamic> data) {
    final msg = data['Msg'] as String?;
    final name = data['fileName'] as String?;
    final bytes = data['fileBytes'] as List<int>?;

    return FileData(msg: msg, name: name, bytes: bytes);
  }
}

class DocData {
  DocData({this.msg, this.rowNumber, this.rows});

  final String? msg;
  final int? rowNumber;
  final Map<String, dynamic>? rows;

  factory DocData.fromJson(Map<String, dynamic> data) {
    final msg = data['Msg'] as String?;
    final docData = jsonDecode(data['Data']) as Map<String, dynamic>?;

    final rowNumber = docData?["RowNumber"] as String?;
    final rows = jsonDecode(docData?["Rows"]) as Map<String, dynamic>?;

    return DocData(
        msg: msg, rowNumber: int.parse(rowNumber ?? "0"), rows: rows);
  }
}
