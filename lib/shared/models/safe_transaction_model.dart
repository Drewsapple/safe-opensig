import 'dart:typed_data';

import 'package:safe_verify/shared/constants/safe_hashes.dart';
import 'package:safe_verify/shared/models/safe_account_model.dart';
import 'package:safe_verify/shared/utils/abi_utils.dart';
import 'package:version/version.dart';
import 'package:wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';

class SafeTransaction {
  String to;
  BigInt value;
  String data;
  int operation;
  BigInt safeTxGas;
  BigInt baseGas;
  BigInt gasPrice;
  String gasToken;
  String refundReceiver;

  SafeTransaction({
    required this.to,
    required this.value,
    required this.data,
    required this.operation,
    required this.safeTxGas,
    required this.baseGas,
    required this.gasPrice,
    required this.gasToken,
    required this.refundReceiver,
  });

  factory SafeTransaction.fromJson(Map<String, dynamic> json) {
    return SafeTransaction(
      to: json['to'] as String,
      value: json['value'] as BigInt,
      data: json['data'] as String,
      operation: json['operation'] as int,
      safeTxGas: json['safeTxGas'] as BigInt,
      baseGas: json['baseGas'] as BigInt,
      gasPrice: json['gasPrice'] as BigInt,
      gasToken: json['gasToken'] as String,
      refundReceiver: json['refundReceiver'] as String,
    );
  }

  Future<(bool, String)> getMessageHash(SafeAccount account, {BigInt? nonce}) async {
    String safeTxTypeHash = SAFE_TX_TYPEHASH;
    var _version = Version.parse(account.version);
    if (_version <= Version.parse("1.2.0")){
      safeTxTypeHash = SAFE_TX_TYPEHASH_OLD;
    }
    if (nonce == null){
      nonce = await account.getNonce();
      if (nonce == null){
        return (false, "Failed to fetch nonce");
      }
    }
    Uint8List message = encodeAbi(
        [
          "bytes32",
          "address",
          "uint256",
          "bytes32",
          "uint8",
          "uint256",
          "uint256",
          "uint256",
          "address",
          "address",
          "uint256",
        ],
        [
          hexToBytes(safeTxTypeHash),
          EthereumAddress.fromHex(to),
          value,
          keccak256(hexToBytes(data)),
          BigInt.from(operation),
          safeTxGas,
          baseGas,
          gasPrice,
          EthereumAddress.fromHex(gasToken),
          EthereumAddress.fromHex(refundReceiver),
          nonce,
        ]
    );
    var messageHash = bytesToHex(keccak256(message), include0x: true);
    return (true, messageHash);
  }

  String getTransactionHash(String domainHash, String messageHash) {
    var transactionData = solidityPack(
        ["bytes1", "bytes1", "bytes32", "bytes32"],
        [Uint8List.fromList([0x19]), Uint8List.fromList([0x01]), hexToBytes(domainHash), hexToBytes(messageHash)]
    );
    var txHash = bytesToHex(keccak256(transactionData), include0x: true);
    return txHash;
  }

  Future<(bool, String, String, String)> calculateHashes(SafeAccount account, {BigInt? nonce}) async {
    if (nonce == null){
      nonce = await account.getNonce();
      if (nonce == null){
        return (false, "Failed to fetch nonce", '', '');
      }
    }
    var domainHash = account.getDomainHash();
    var (success, messageHash) = await getMessageHash(account, nonce: nonce);
    if (!success){
      return (false, "Failed to calculate message hash", '', '');
    }
    var txHash = getTransactionHash(domainHash, messageHash);
    return (true, domainHash, messageHash, txHash);
  }

}
