import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import '../models/network_model.dart';

var availableNetworks = {
  // L1s
  1: Network(
    name: 'Ethereum',
    chainPrefix: 'eth',
    chainId: 1,
    nativeCurrencySymbol: "ETH",
    provider: Web3Client("https://ethereum-rpc.publicnode.com", Client()),
    logoUri: null,
  ),
  137: Network(
    name: 'Polygon',
    chainPrefix: 'pol',
    chainId: 137,
    nativeCurrencySymbol: "POL",
    provider: Web3Client("https://polygon-bor-rpc.publicnode.com", Client()),
    logoUri: null,
  ),
  100: Network(
    name: 'Gnosis',
    chainPrefix: 'gno',
    chainId: 100,
    nativeCurrencySymbol: "xDAI",
    provider: Web3Client("https://gnosis-rpc.publicnode.com", Client()),
    logoUri: null,
  ),
  56: Network(
    name: 'BSC',
    chainPrefix: 'bnb',
    chainId: 56,
    nativeCurrencySymbol: "BNB",
    provider: Web3Client("https://bsc-rpc.publicnode.com", Client()),
    logoUri: null,
  ),
  43114: Network(
    name: 'Avalanche',
    chainPrefix: 'avax',
    chainId: 43114,
    nativeCurrencySymbol: "AVAX",
    provider: Web3Client("https://avalanche-c-chain-rpc.publicnode.com", Client()),
    logoUri: null,
  ),
  // L2s
  10: Network(
    name: 'Optimism',
    chainPrefix: 'oeth',
    chainId: 10,
    nativeCurrencySymbol: "ETH",
    provider: Web3Client("https://optimism-rpc.publicnode.com", Client()),
    logoUri: null,
  ),
  8453: Network(
    name: 'Base',
    chainPrefix: 'base',
    chainId: 8453,
    nativeCurrencySymbol: "ETH",
    provider: Web3Client("https://base-rpc.publicnode.com", Client()),
    logoUri: null,
  ),
  480: Network(
    name: 'Worldchain',
    chainPrefix: 'wc',
    chainId: 480,
    nativeCurrencySymbol: "ETH",
    provider: Web3Client("https://worldchain.drpc.org", Client()),
    logoUri: null,
  ),
  130: Network(
    name: 'Unichain',
    chainPrefix: 'unichain',
    chainId: 130,
    nativeCurrencySymbol: "ETH",
    provider: Web3Client("https://unichain-rpc.publicnode.com", Client()),
    logoUri: null,
  ),
  42161: Network(
    name: 'Arbitrum',
    chainPrefix: 'arb1',
    chainId: 42161,
    nativeCurrencySymbol: "ETH",
    provider: Web3Client("https://arbitrum-one-rpc.publicnode.com", Client()),
    logoUri: null,
  ),
  42220: Network(
    name: 'Celo',
    chainPrefix: 'celo',
    chainId: 42220,
    nativeCurrencySymbol: "cUSD",
    provider: Web3Client("https://celo-rpc.publicnode.com", Client()),
    logoUri: null,
  ),
};
