import 'package:flutter/material.dart';

class WidgetIndexBuilder extends StatelessWidget {
  final int index;
  final List<Widget> widgets;
  const WidgetIndexBuilder({super.key, required this.index, required this.widgets});

  @override
  Widget build(BuildContext context) {
    return widgets[index];
  }
}
