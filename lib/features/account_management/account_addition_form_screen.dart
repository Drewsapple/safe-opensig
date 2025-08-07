import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_verify/core/storage/accounts_box.dart';
import 'package:safe_verify/features/account_management/account_state_provider.dart';
import 'package:safe_verify/shared/constants/event_bus.dart';
import 'package:safe_verify/shared/widgets/address_input_field.dart';
import 'package:safe_verify/shared/constants/network_constants.dart';
import 'package:safe_verify/shared/models/network_model.dart';
import 'package:safe_verify/shared/models/safe_account_model.dart';
import 'package:safe_verify/shared/widgets/network_logo.dart';
import 'package:uuid/uuid.dart';

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
  
  Network? _selectedNetwork;
  String? _selectedVersion;

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
      if (_selectedNetwork == null) {
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

      if (AccountsBox.accountExists(_addressController.text, _selectedNetwork!.chainId)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An account with this address already exists on the selected network')),
        );
        return;
      }

      final account = SafeAccount(
        id: const Uuid().v4(),
        name: _nameController.text,
        address: _addressController.text,
        chainId: _selectedNetwork!.chainId,
        version: _selectedVersion!,
      );
      ref.read(accountsProvider.notifier).addAccount(account);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account added successfully!')),
      );
      GoRouter.of(context).pop();
    }
  }

  @override
  void initState() {
    _networkDetectionSubscription = eventBus.on<OnAddressNetworkDetected>().listen((event){
      setState(() {
        _selectedNetwork = event.network;
      });
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
                value: _selectedNetwork,
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
                    _selectedNetwork = newValue;
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
                    child: Text(version),
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