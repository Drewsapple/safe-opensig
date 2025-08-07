import 'package:equatable/equatable.dart';
import 'package:web3dart/web3dart.dart';

class Network extends Equatable {
  final String name;
  final String chainPrefix;
  final int chainId;
  final String nativeCurrencySymbol;
  final Web3Client provider;
  final String? logoUri;

  Network({
    required this.name,
    required this.chainPrefix,
    required this.chainId,
    required this.nativeCurrencySymbol,
    required this.provider,
    this.logoUri,
  });

  @override
  List<Object> get props => [chainId];
}