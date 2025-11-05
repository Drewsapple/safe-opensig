import 'package:safe_verify/shared/models/simulation/safe_setting_change.dart';
import 'package:safe_verify/shared/models/simulation/token_allowance.dart';
import 'package:safe_verify/shared/models/simulation/token_transfer.dart';
import 'package:safe_verify/shared/models/simulation/warning_transaction.dart';


class SimulationResult {
  bool success;
  String revertReason;
  List<TokenTransfer> transfers;
  List<TokenAllowance> allowances;
  List<SafeSettingChange> safeSettingsChanges;
  List<WarningTransaction> warningTransactions;

  SimulationResult({
    required this.success,
    required this.revertReason,
    required this.transfers,
    required this.allowances,
    required this.safeSettingsChanges,
    required this.warningTransactions,
  });

  Future<void> loadTokenMetadatas() async {
    for (var transfer in transfers){
      await transfer.fetchMetadata();
    }
  }
}
