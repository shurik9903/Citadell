import 'package:flutter/material.dart';
import 'package:flutter_univ/data/AnalysisTextData.dart';

class RowTableData {
  RowTableData(
      {this.number,
      this.type,
      this.source,
      this.contentText,
      this.originalText,
      this.date,
      this.analyzedText,
      this.probability,
      this.update,
      this.check});

  String? number;
  String? type;
  String? source;
  String? contentText;
  String? originalText;
  String? date;
  List<AnalysisTextData>? analyzedText;
  String? probability;
  String? update;
  String? check;
}
