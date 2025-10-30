import 'package:safe_verify/shared/models/network_model.dart';
import 'package:safe_verify/shared/utils/abi_utils.dart';
import 'package:wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';

class TokenMetadata {
  String name;
  String symbol;
  int decimals;
  String? logoUri;

  TokenMetadata({
    required this.name,
    required this.symbol,
    required this.decimals,
    this.logoUri
  });

  static Future<TokenMetadata> fromAddress(EthereumAddress address, Network network) async {
    var results = await Future.wait([
      network.provider.callRaw(contract: address,data: hexToBytes("0x06fdde03")),
      network.provider.callRaw(contract: address, data: hexToBytes("0x95d89b41")),
      network.provider.callRaw(contract: address, data: hexToBytes("0x313ce567"))
    ]);
    var nameHex = results[0];
    var symbolHex = results[1];
    var decimalsHex = results[2];
    String name = decodeAbi(["string"], hexToBytes(nameHex))[0];
    String symbol = decodeAbi(["string"], hexToBytes(symbolHex))[0];
    int decimals = BigInt.parse(decimalsHex.replaceFirst("0x", ""), radix: 16).toInt();
    return TokenMetadata(
      name: name,
      symbol: symbol,
      decimals: decimals
    );
  }
}