import 'package:safe_verify/shared/models/simulation/token_metadata.dart';
import 'package:wallet/wallet.dart';

class TokenAllowance {
  EthereumAddress token;
  EthereumAddress spender;
  BigInt amount;
  TokenMetadata? metadata;

  TokenAllowance({
    required this.token,
    required this.spender,
    required this.amount,
    this.metadata
  });
}