import '../models/network_model.dart';


var availableNetworks = {
  // L1s
  1: Network(
    name: 'Ethereum',
    chainPrefix: 'eth',
    chainId: 1,
    logoUri: 'https://cryptologos.cc/logos/ethereum-eth-logo.png?v=040',
    nativeCurrencySymbol: "ETH"
  ),
  137: Network(
    name: 'Polygon',
    chainPrefix: 'pol',
    chainId: 137,
    logoUri: 'https://cryptologos.cc/logos/polygon-matic-logo.png?v=040',
    nativeCurrencySymbol: "POL"
  ),
  100: Network(
      name: 'Gnosis',
      chainPrefix: 'gno',
      chainId: 100,
      logoUri: 'https://cryptologos.cc/logos/gnosis-gno-gno-logo.png?v=040',
      nativeCurrencySymbol: "xDAI"
  ),
  56: Network(
      name: 'BSC',
      chainPrefix: 'bnb',
      chainId: 56,
      logoUri: 'https://cryptologos.cc/logos/bnb-bnb-logo.png?v=040',
      nativeCurrencySymbol: "BNB"
  ),
  43114: Network(
      name: 'Avalanche',
      chainPrefix: 'avax',
      chainId: 43114,
      logoUri: 'https://cryptologos.cc/logos/avalanche-avax-logo.png?v=040',
      nativeCurrencySymbol: "AVAX"
  ),
  // L2s
  10: Network(
      name: 'Optimism',
      chainPrefix: 'oeth',
      chainId: 10,
      logoUri: 'https://cryptologos.cc/logos/optimism-ethereum-op-logo.png?v=040',
      nativeCurrencySymbol: "ETH"
  ),
  8453: Network(
      name: 'Base',
      chainPrefix: 'base',
      chainId: 8453,
      logoUri: 'https://altcoinsbox.com/wp-content/uploads/2022/12/coinbase-logo.png',
      nativeCurrencySymbol: "ETH"
  ),
  480: Network(
      name: 'Worldchain',
      chainPrefix: 'wc',
      chainId: 480,
      logoUri: 'https://cryptologos.cc/logos/worldcoin-org-wld-logo.png?v=040',
      nativeCurrencySymbol: "ETH"
  ),
  130: Network(
      name: 'Unichain',
      chainPrefix: 'unichain',
      chainId: 130,
      logoUri: 'https://cryptologos.cc/logos/uniswap-uni-logo.png?v=040',
      nativeCurrencySymbol: "ETH"
  ),
  42161: Network(
      name: 'Arbitrum',
      chainPrefix: 'arb1',
      chainId: 42161,
      logoUri: 'https://cryptologos.cc/logos/arbitrum-arb-logo.png?v=040',
      nativeCurrencySymbol: "ETH"
  ),
  42220: Network(
      name: 'Celo',
      chainPrefix: 'celo',
      chainId: 42220,
      logoUri: 'https://cryptologos.cc/logos/celo-celo-logo.png?v=040',
      nativeCurrencySymbol: "cUSD"
  ),
};