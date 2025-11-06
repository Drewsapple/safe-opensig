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
    var futures = <Future>[];
    var visitedTokens = <String>{};
    for (var transfer in transfers){
      var tokenAddress = transfer.token.with0x;
      if (visitedTokens.contains(tokenAddress)) continue;
      visitedTokens.add(transfer.token.with0x);
      futures.add(transfer.fetchMetadata());
    }
    // Fetch metadata of distinct set of tokens
    await Future.wait(futures);
    // Then fetch metadata of metadata that are still null (recurring tokens, will fetch from cache)
    for (var transfer in transfers){
      if (transfer.metadata == null){
        await transfer.fetchMetadata();
      }
    }
  }
}
