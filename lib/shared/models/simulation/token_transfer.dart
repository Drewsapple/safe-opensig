import 'package:safe_opensig/shared/models/network_model.dart';
import 'package:safe_opensig/shared/models/simulation/token_metadata.dart';
import 'package:wallet/wallet.dart';

class TokenTransfer {
  EthereumAddress token;
  EthereumAddress sender;
  EthereumAddress recipient;
  BigInt amount;
  Network network;
  TokenMetadata? metadata;

  TokenTransfer({
    required this.token,
    required this.sender,
    required this.recipient,
    required this.amount,
    required this.network,
    this.metadata
  });

  Future<void> fetchMetadata() async {
    metadata = await TokenMetadata.fromAddress(token, network);
  }
}