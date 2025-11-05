enum WarningTransactionType {
  MODULE_ADDITION,
  MODULE_REVOCATION,
  MODULE_GUARD_CHANGE,
  GUARD_CHANGE,
  DELEGATE_CALL,
}

class WarningTransaction {
  WarningTransactionType type;
  List<dynamic> data;

  WarningTransaction({
    required this.type,
    required this.data
  });
}