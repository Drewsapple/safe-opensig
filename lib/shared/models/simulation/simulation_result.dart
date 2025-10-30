import 'package:safe_verify/shared/models/simulation/safe_setting_change.dart';
import 'package:safe_verify/shared/models/simulation/token_allowance.dart';
import 'package:safe_verify/shared/models/simulation/token_transfer.dart';
import 'package:safe_verify/shared/models/simulation/warning_transaction.dart';


class SimulationResult {
  List<TokenTransfer> transfers;
  List<TokenAllowance> allowances;
  List<SafeSettingChange> safeSettingsChanges;
  List<WarningTransaction> warningTransactions;

  SimulationResult({
    required this.transfers,
    required this.allowances,
    required this.safeSettingsChanges,
    required this.warningTransactions,
  });
}
