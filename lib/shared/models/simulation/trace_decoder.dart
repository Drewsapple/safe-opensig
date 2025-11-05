import 'package:safe_verify/shared/models/network_model.dart';
import 'package:safe_verify/shared/models/simulation/safe_setting_change.dart';
import 'package:safe_verify/shared/models/simulation/simulation_result.dart';
import 'package:safe_verify/shared/models/simulation/token_allowance.dart';
import 'package:safe_verify/shared/models/simulation/token_transfer.dart';
import 'package:safe_verify/shared/models/simulation/warning_transaction.dart';
import 'package:safe_verify/shared/utils/abi_utils.dart';
import 'package:wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';

var _logsMapping = {
  "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef": "erc20-transfer",
  "0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925": "erc20-allowance-change",
  //
  "0x9465fa0c962cc76958e6373a993326400c1c94f8be2fe3a952adfa7f60b2ea26": "safe-owner-addition",
  "0xf8d49fc529812e9a7c5c50e69c20f0dccc0db8fa95c98bc58cc9a4f1c1299eaf": "safe-owner-revocation",
  "0x610f7ff2b304ae8903c3de74c60c6ab1f7d6226b3f52c5161905bb5ad4039c93": "safe-threshold-change",
  //
  "0xecdf3a3effea5783a3c4c2140e677577666428d44ed9d474a0b3a4c9943f8440": "safe-module-enable",
  "0xaab4fa2b463f581b2b32cb3b7e3b704b9ce37cc209b5fb4d77e593ace4054276": "safe-module-disable",
  "0xcd1966d6be16bc0c030cc741a06c6e0efaf8d00de2c8b6a9e11827e125de8bb8": "safe-module-guard-change",
  //
  "0x1151116914515bc0891ff9047a6cb32cf902546f83066499bcf8ba33d2353fa2": "safe-guard-change",
};

class TraceDecoder {

  static dynamic processLog(String account, Network network, Map<String, dynamic> log){
    account = account.toLowerCase();
    var topics = (log["topics"] as List<dynamic>).cast<String>();
    var eventSignature = topics[0].toLowerCase();
    if (_logsMapping.containsKey(eventSignature)){
      var eventName = _logsMapping[eventSignature]!;
      var emittedBy = EthereumAddress.fromHex(log["address"]);
      if (eventName.startsWith("safe") && emittedBy.with0x.toLowerCase() != account) return null;
      if (eventName == "erc20-transfer"){
        var sender = decodeAbi(["address"], hexToBytes(topics[1]))[0] as EthereumAddress;
        var recipient = decodeAbi(["address"], hexToBytes(topics[2]))[0] as EthereumAddress;
        if (sender.with0x.toLowerCase() != account && recipient.with0x.toLowerCase() != account) return null;
        var amount = decodeAbi(["uint256"], hexToBytes(log["data"]))[0] as BigInt;
        return TokenTransfer(
          token: emittedBy,
          sender: sender,
          recipient: recipient,
          amount: amount,
          network: network
        );
      } else if (eventName == "erc20-allowance-change"){
        var owner = decodeAbi(["address"], hexToBytes(topics[1]))[0] as EthereumAddress;
        if (owner.with0x.toLowerCase() != account) return null;
        var spender = decodeAbi(["address"], hexToBytes(topics[2]))[0] as EthereumAddress;
        var amount = decodeAbi(["uint256"], hexToBytes(log["data"]))[0] as BigInt;
        return TokenAllowance(
          token: emittedBy,
          spender: spender,
          amount: amount
        );
      }else if (eventName == "safe-owner-addition"){
        var addedOwner = decodeAbi(["address"], hexToBytes(topics[1]))[0] as EthereumAddress;
        return SafeSettingChange(
          type: SafeSettingChangeType.OWNER_ADDITION,
          data: [addedOwner]
        );
      }else if (eventName == "safe-owner-revocation"){
        var revokedOwner = decodeAbi(["address"], hexToBytes(topics[1]))[0] as EthereumAddress;
        return SafeSettingChange(
          type: SafeSettingChangeType.OWNER_REVOCATION,
          data: [revokedOwner]
        );
      }else if (eventName == "safe-threshold-change"){
        var newThreshold = decodeAbi(["uint256"], hexToBytes(log["data"]))[0] as BigInt;
        return SafeSettingChange(
          type: SafeSettingChangeType.THRESHOLD_CHANGE,
          data: [newThreshold]
        );
      }else if (eventName == "safe-module-enable"){
        var newModule = decodeAbi(["address"], hexToBytes(topics[1]))[0] as EthereumAddress;
        return WarningTransaction(
          type: WarningTransactionType.MODULE_ADDITION,
          data: [newModule]
        );
      }else if (eventName == "safe-module-disable"){
        var disabledModule = decodeAbi(["address"], hexToBytes(topics[1]))[0] as EthereumAddress;
        return WarningTransaction(
          type: WarningTransactionType.MODULE_REVOCATION,
          data: [disabledModule]
        );
      }else if (eventName == "safe-module-guard-change"){
        var newModuleGuard = decodeAbi(["address"], hexToBytes(topics[1]))[0] as EthereumAddress;
        return WarningTransaction(
          type: WarningTransactionType.MODULE_GUARD_CHANGE,
          data: [newModuleGuard]
        );
      }else if (eventName == "safe-guard-change"){
        var newGuard = decodeAbi(["address"], hexToBytes(topics[1]))[0] as EthereumAddress;
        return WarningTransaction(
          type: WarningTransactionType.GUARD_CHANGE,
          data: [newGuard]
        );
      }
    }
    return null;
  }

  static void processCall(String account, Network network, Map<String, dynamic> call, List<TokenTransfer> result){
    var from = call["inputs"]["caller"].toString().toLowerCase();
    var to = call["inputs"]["target_address"].toString().toLowerCase();
    if (from == account.toLowerCase() || to == account.toLowerCase()){
      var inputValue = call["inputs"]["value"] as Map<String, dynamic>;
      if (inputValue.containsKey("Transfer")){
        var amount = BigInt.parse(inputValue["Transfer"].toString().replaceFirst("0x", ""), radix: 16);
        if (amount > BigInt.zero){
          var sender = EthereumAddress.fromHex(from);
          var recipient = EthereumAddress.fromHex(to);
          if (sender != recipient){
            result.add(
              TokenTransfer(
                token: EthereumAddress.fromHex("0x0000000000000000000000000000000000000000"),
                sender: sender,
                recipient: recipient,
                amount: amount,
                network: network
              )
            );
          }
        }
      }
    }
    if (call["calls"].length > 0){
      for (var _internalCall in call["calls"]){
        processCall(account, network, _internalCall, result);
      }
    }
  }

  static SimulationResult decode(String account, Network network, Map<String, dynamic> trace){
    var executionResult = trace["execution_result"] as Map<String, dynamic>;
    if (!executionResult.containsKey("Success")) {
      return SimulationResult(
        success: false,
        revertReason: "0x",
        transfers: [],
        allowances: [],
        safeSettingsChanges: [],
        warningTransactions: []
      );
    }
    List<TokenTransfer> transfers = [];
    List<TokenAllowance> allowances = [];
    List<SafeSettingChange> safeSettingsChanges = [];
    List<WarningTransaction> warningTransactions = [];
    //
    var logs = executionResult["Success"]["logs"];
    for (var log in logs){
      var decodedLog = processLog(account, network, log);
      if (decodedLog == null) continue;
      if (decodedLog is TokenTransfer){
        transfers.add(decodedLog);
      }else if (decodedLog is TokenAllowance){
        allowances.add(decodedLog);
      }else if (decodedLog is SafeSettingChange){
        safeSettingsChanges.add(decodedLog);
      }else if (decodedLog is WarningTransaction){
        warningTransactions.add(decodedLog);
      }
    }
    //
    List<TokenTransfer> nativeTokenTransfers = [];
    var callFrame = trace["trace"];
    processCall(account, network, callFrame, nativeTokenTransfers);
    transfers.addAll(nativeTokenTransfers);
    return SimulationResult(
      success: true,
      revertReason: "0x",
      transfers: transfers,
      allowances: allowances,
      safeSettingsChanges: safeSettingsChanges,
      warningTransactions: warningTransactions
    );
  }
}