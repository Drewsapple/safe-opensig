import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:safe_verify/shared/constants/network_constants.dart';
import 'package:safe_verify/shared/constants/safe_hashes.dart';
import 'package:safe_verify/shared/models/network_model.dart';
import 'package:safe_verify/shared/utils/abi_utils.dart';
import 'package:version/version.dart';
import 'package:wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';

class SafeAccount extends HiveObject with EquatableMixin {
  final String id;
  final String name;
  final String address;
  final int chainId;
  final String version;

  SafeAccount({
    required this.id,
    required this.name,
    required this.address,
    required this.chainId,
    required this.version,
  });

  Network get network => availableNetworks[chainId]!;

  @override
  List<Object> get props => [id, address];

  SafeAccount copyWith({
    String? id,
    String? name,
    String? address,
    int? chainId,
    String? version,
  }) {
    return SafeAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      chainId: chainId ?? this.network.chainId,
      version: version ?? this.version,
    );
  }

  String getDomainHash(){
    String domainSeparatorTypeHash = DOMAIN_SEPARATOR_TYPEHASH;
    var _version = Version.parse(this.version);
    Uint8List encodedDomain;
    if (_version <= Version.parse("1.2.0")){
      domainSeparatorTypeHash = DOMAIN_SEPARATOR_TYPEHASH_OLD;
      encodedDomain = encodeAbi(
        ["bytes32", "address"],
        [hexToBytes(domainSeparatorTypeHash), EthereumAddress.fromHex(this.address)]
      );
    }else{
      encodedDomain = encodeAbi(
        ["bytes32", "uint256", "address"],
        [hexToBytes(domainSeparatorTypeHash), BigInt.from(network.chainId), EthereumAddress.fromHex(this.address)]
      );
    }
    return bytesToHex(keccak256(encodedDomain), include0x: true);
  }

  Future<BigInt?> getNonce() async {
    try {
      var response = await network.provider.callRaw(
          contract: EthereumAddress.fromHex(address),
          data: hexToBytes("0xaffed0e0")
      );
      return BigInt.parse(response);
    } catch (e) {
      return null;
    }
  }

}