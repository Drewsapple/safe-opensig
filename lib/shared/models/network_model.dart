import 'package:equatable/equatable.dart';

class Network extends Equatable {
  final String name;
  final int chainId;
  final String nativeCurrencySymbol;
  final String? logoUri;

  Network({
    required this.name,
    required this.chainId,
    required this.nativeCurrencySymbol,
    this.logoUri,
  });

  @override
  List<Object> get props => [chainId];
}