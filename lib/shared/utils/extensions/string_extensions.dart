import 'package:safe_verify/shared/utils/utilities.dart';

extension StringExtensions on String {
  bool get isNumericOnly => Utilities.hasMatch(this, r'^\d+$');
}