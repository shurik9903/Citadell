import 'package:flutter/material.dart';

class MAnalysisText extends StatefulWidget {
  List<TextSpan>? parseText;

  MAnalysisText({super.key, this.parseText});

  @override
  State<MAnalysisText> createState() => _MAnalysisTextState();
}

class _MAnalysisTextState extends State<MAnalysisText> {
  late List<TextSpan> _parseText;

  @override
  void initState() {
    super.initState();
    _parseText = widget.parseText ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return RichText(text: TextSpan(children: _parseText));
  }
}
