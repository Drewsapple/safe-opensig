import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:safe_verify/core/theme/theme_config.dart';
import 'package:safe_verify/shared/constants/event_bus.dart';
import 'package:safe_verify/shared/constants/network_constants.dart';

import 'address_qr_scanner_sheet.dart';

class AddressInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AddressInputField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  State<AddressInputField> createState() => _AddressInputFieldState();
}

class _AddressInputFieldState extends State<AddressInputField> {
  bool get _isMobilePlatform {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  Future<void> _startScanning() async {
    if (!_isMobilePlatform) return;
    showModalBottomSheet(
      context: context,
      builder: (context) => AddressQrScannerSheet(
        onScanAddress: (address, prefix){
          widget.controller.text = address;
          if (prefix.isEmpty) return;
          for (var network in availableNetworks.values){
            if (network.chainPrefix == prefix){
              eventBus.fire(OnAddressNetworkDetected(network));
              break;
            }
          }
        },
      ),
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConfig.borderRadiusLarge,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: 'Account Address',
              border: OutlineInputBorder(),
              suffixIcon: _isMobilePlatform ? IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: _startScanning,
              ) : null,
            ),
            validator: widget.validator,
          ),
        ),
      ],
    );
  }
}