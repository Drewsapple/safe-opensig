# Changelog

All notable changes to Safe OpenSig will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
## [1.1.2+7]

### Added
- Explore popular Safes section on empty accounts screen for new-user onboarding (#63)
- Privacy note ("Saved locally · never shared") on account addition form (#62)
- Privacy onboarding page explaining local-only data storage (#62)
- Privacy line in About dialog (#62)

### Changed
- Hide nonce control when nonce is provided explicitly (API/JSON input); only show editable nonce for calldata input path (#60)
- Nonce now included in transaction JSON card display (#60)

### Fixed
- Delegate call warning no longer triggers for trusted MultiSend/MultiSendCallOnly contracts in Safe API transaction list (#59)
- Token decimals capped to uint8 max (255) to prevent hangs from malformed contract responses (#58)
- Token decimals decoding uses proper ABI uint8 decoding instead of raw hex parsing (#58)

## [1.1.1]

### Fixed
- Retries for `debug_traceCall` and `eth_getProof`; use `latestBlock-1` for state/simulation (#56)
- Use correct version from package info instead of hardcoded values (#57)

## [1.1.0]

### Added
- ERC-1155 (semi-fungible token) support in transaction simulation (#49)
- On-chain verification that Safe is deployed and version matches before account addition (#52)
- Safe v1.5.0 added to version dropdown selections (#52)
- Hold-to-confirm button for simulation results with improved user confidence (#53)
- Support for Ledger Nano S Plus and Ledger Nano X hardware wallet emulation (#29)
- Interactive address widget with expandable details view and block explorer links (#34)
- Network configuration override capability for custom RPC endpoints (#42)
- Secondary node requirement (minimum 1) for state verification
- Support for Safe Transaction Service API keys from environment variables (#50)
- Back and skip navigation buttons to Ledger verification screen (#26)
- CLAUDE.md documentation and UX security review skill (#39)

### Changed
- Improved card UI/UX with minimal design approach (#27)
- Updated README with new project name and identity (#40)
- Enhanced RPC error handling to properly detect unsupported methods (#51)

### Fixed
- REVM gas limit errors and edge cases in simulation (#48)
- Queued transactions now only show for latest and future nonces (#25)
- Missing excessBlobGas field in block data for REVM compatibility (#24)
- Nonce overflow handling for large numbers in verification screen (#21)
- Skip button behavior in onboarding flow (#28)

## [1.0.0] - 2026-01-21

### Added
- EVM state verification with multi-node consensus using Merkle Patricia Trie proofs (#8)
- Safe Transaction Service API integration for fetching queued transactions (#12)
- Local storage migration system with schema versioning support (#15)
- Separate nonce handling for simulation vs verification workflows (#11)
- RLP encoding/decoding test coverage (#9)
- SafeArea margins for app scaffold

### Changed
- Updated app branding to "Safe OpenSig" (#10)
- Changed bundle ID to com.candidelabs.opensig
- Updated launcher icon with new branding
- Bumped Android compileSdk and minSdk versions
- Pinned all dependencies to exact versions for reproducibility
- Made router redirects synchronous for improved performance
- Updated iOS Xcode project settings

### Fixed
- Non-existent account verification in state proofs (#13)
- Migration completion flag now properly resets

## [0.4.0] - 2025-12-30

### Added
- NFT support in transaction simulation (ERC-721) (#7)
- UI for NFT approval revocation display
- Token allowance deduction when transferFrom is detected
- Allowance tracking in trace decoding
- Delegate call detection and display
- Singleton/implementation change detection for Safe contracts (#6)
- Missing native token metadata for supported networks

### Changed
- Decoupled REVM tracing into separate library for reusability
- Parallel loading of token metadata for improved performance
- Updated Podfile.lock

## [0.3.0] - 2025-11-06

### Added
- Transaction simulation page with detailed execution traces
- REVM (Rust EVM) tracer integration for local transaction execution
- Trace output decoding with human-readable action descriptions
- UI state handling for failed simulations

### Changed
- Optimized token metadata loading with parallel requests

## [0.2.0] - 2025-10-26

### Added
- Ledger hardware wallet verification support
- Visual preview of transaction data as displayed on Ledger devices
- Ledger Nano S emulation with accurate screen rendering

## [0.1.0] - 2025-08-22

### Added
- Initial project setup and core architecture
- Transaction form and verification screens
- QR code scanning for address input with chain prefix detection (EIP-3770)
- Account version detection for Safe contracts
- Support for Safe versions prior to 1.0.0 (legacy type hash)
- Nonce input control with stepper interface
- Keyboard action toolbar for verification form
- Account editing and deletion capabilities
- iOS workspace configuration and camera permission handling
- Android release configuration
- Placeholder guide assets

### Changed
- Updated app bar theme to use Material Design defaults
- Removed deprecated fields from ThemeData

### Fixed
- Empty response decoding skipped to prevent errors
- CallData input JSON viewer sheet scrolling issue
- iOS camera permission request flow
- Nonce stepper tooltip interference with hold gestures
- Empty calldata display now shows '0x' instead of empty string

---

## Version History Summary

- **v1.1.2** (2026-03-01) - Popular Safes exploration, privacy notes, nonce UX, and bug fixes
- **v1.1.1** (2026-02-17) - RPC reliability improvements and version display fix
- **v1.1.0** (2026-02-15) - ERC-1155 support, on-chain Safe deployment verification, and UX improvements
- **v1.0.0** (2026-01-21) - Production release with state verification and API integration
- **v0.4.0** (2025-12-30) - NFT support and advanced trace decoding
- **v0.3.0** (2025-11-06) - Transaction simulation with REVM
- **v0.2.0** (2025-10-26) - Ledger hardware wallet verification
- **v0.1.0** (2025-08-22) - Initial release with core functionality

## Links

- [Repository](https://github.com/candidelabs/safe-opensig)
- [Documentation](./README.md)
- [License](./LICENSE)
