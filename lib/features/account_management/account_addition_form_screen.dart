import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_verify/core/storage/accounts_box.dart';
import 'package:safe_verify/features/account_management/account_state_provider.dart';
import 'package:safe_verify/shared/constants/event_bus.dart';
import 'package:safe_verify/shared/constants/network_constants.dart';
import 'package:safe_verify/shared/models/network_model.dart';
import 'package:safe_verify/shared/models/safe_account_model.dart';
import 'package:safe_verify/shared/utils/abi_utils.dart';
import 'package:safe_verify/shared/widgets/address_input_field.dart';
import 'package:safe_verify/shared/widgets/network_logo.dart';
import 'package:uuid/uuid.dart';
import 'package:wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';


class AccountAdditionFormScreen extends ConsumerStatefulWidget {
  const AccountAdditionFormScreen({super.key});

  @override
  ConsumerState<AccountAdditionFormScreen> createState() => _AccountAdditionFormScreenState();
}

class _AccountAdditionFormScreenState extends ConsumerState<AccountAdditionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  late StreamSubscription _networkDetectionSubscription;

  final ValueNotifier<Network?> _selectedNetwork = ValueNotifier(null);
  String _safeAddress = "";
  String? _selectedVersion;
  String? _recommendedVersion;

  final List<String> _versions = [
    '1.4.1',
    '1.3.0',
    '1.2.0',
    '1.1.1',
    '1.1.0',
    '1.0.0',
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedNetwork.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a network')),
        );
        return;
      }

      if (_selectedVersion == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a contract version')),
        );
        return;
      }

      if (AccountsBox.accountExists(_addressController.text, _selectedNetwork.value!.chainId)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An account with this address already exists on the selected network')),
        );
        return;
      }

      final account = SafeAccount(
        id: const Uuid().v4(),
        name: _nameController.text,
        address: _addressController.text,
        chainId: _selectedNetwork.value!.chainId,
        version: _selectedVersion!,
      );
      ref.read(accountsProvider.notifier).addAccount(account);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account added successfully!')),
      );
      GoRouter.of(context).pop();
    }
  }

  void updateRecommendedVersion() async {
    setState(() => _recommendedVersion = null);
    if (_selectedNetwork.value == null) return;
    if (!EthereumAddress.isEip55ValidEthereumAddress(_safeAddress)) return;
    var response = "";
    try {
      response = await _selectedNetwork.value!.provider.callRaw(
        contract: EthereumAddress.fromHex(_addressController.text),
        data: hexToBytes("0xffa1ad74")
      );
    } catch (e) {
      return;
    }
    if (response.replaceAll("0x", "").isEmpty) return;
    var version = decodeAbi(["string"], hexToBytes(response))[0];
    if (_versions.contains(version)){
      _selectedVersion ??= version;
      _recommendedVersion = version;
      setState(() {});
    }
  }

  @override
  void initState() {
    _networkDetectionSubscription = eventBus.on<OnAddressNetworkDetected>().listen((event){
      setState(() {
        _selectedNetwork.value = event.network;
      });
    });
    _selectedNetwork.addListener((){
      updateRecommendedVersion();
    });
    _addressController.addListener((){
      var value = _addressController.text;
      if (_safeAddress == value) return;
      _safeAddress = value;
      if (EthereumAddress.isEip55ValidEthereumAddress(value)){
        updateRecommendedVersion();
        return;
      }else{
        if (value.contains(":")){
          var prefix = value.split(":")[0];
          var address = value.split(":")[1];
          if (EthereumAddress.isEip55ValidEthereumAddress(address)){
            for (var network in availableNetworks.values){
              if (network.chainPrefix == prefix){
                eventBus.fire(OnAddressNetworkDetected(network));
                break;
              }
            }
            _addressController.text = address;
            return;
          }
        }
      }
      setState(() => _recommendedVersion = null);
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _networkDetectionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Account Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an account name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AddressInputField(
                controller: _addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an account address';
                  }
                  if (!value.startsWith('0x') || value.length != 42) {
                    return 'Please enter a valid account address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Network>(
                value: _selectedNetwork.value,
                decoration: const InputDecoration(
                  labelText: 'Network',
                  border: OutlineInputBorder(),
                ),
                items: availableNetworks.values.map((Network network) {
                  return DropdownMenuItem<Network>(
                    value: network,
                    child: Row(
                      children: [
                        NetworkLogo(network: network),
                        const SizedBox(width: 12),
                        Text(network.name),
                      ],
                    ),
                  );
                }).toList(),
                selectedItemBuilder: (BuildContext context) {
                  return availableNetworks.values.map<Widget>((Network network) {
                    return Row(
                      children: [
                        NetworkLogo(network: network),
                        const SizedBox(width: 12),
                        Text(network.name),
                      ],
                    );
                  }).toList();
                },
                onChanged: (Network? newValue) {
                  setState(() {
                    _selectedNetwork.value = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a network';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedVersion,
                decoration: const InputDecoration(
                  labelText: 'Contract Version',
                  border: OutlineInputBorder(),
                ),
                items: _versions.map((String version) {
                  return DropdownMenuItem<String>(
                    value: version,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: version),
                          if (_recommendedVersion == version)
                            TextSpan(
                              text: " (detected)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5)
                              )
                            ),
                        ]
                      )
                    )
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedVersion = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a contract version';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}