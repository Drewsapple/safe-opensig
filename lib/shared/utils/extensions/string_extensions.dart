import 'package:safe_opensig/shared/utils/utilities.dart';

extension StringExtensions on String {
  bool get isNumericOnly => Utilities.hasMatch(this, r'^\d+$');
}