enum SafeSettingChangeType {
  OWNER_ADDITION,
  OWNER_REVOCATION,
  THRESHOLD_CHANGE,
}

class SafeSettingChange {
  SafeSettingChangeType type;
  List<dynamic> data;

  SafeSettingChange({
    required this.type,
    required this.data
  });
}