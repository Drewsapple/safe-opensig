import 'package:safe_verify/shared/models/simulation/token_metadata.dart';
import 'package:wallet/wallet.dart';

class TokenTransfer {
  EthereumAddress token;
  EthereumAddress recipient;
  BigInt amount;
  TokenMetadata? metadata;

  TokenTransfer({
    required this.token,
    required this.recipient,
    required this.amount,
    this.metadata
  });
}