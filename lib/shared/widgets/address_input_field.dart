import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:safe_verify/shared/constants/event_bus.dart';
import 'package:safe_verify/shared/constants/network_constants.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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
    WoltModalSheet.show(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      barrierDismissible: true,
      modalTypeBuilder: (_) => WoltBottomSheetType().copyWith(
        minFlingVelocity: 900,
        closeProgressThreshold: 0.9,
        reverseTransitionDuration: Duration(milliseconds: 350)
      ),
      pageListBuilder: (bottomSheetContext) => [
        WoltModalSheetPage(
          child: AddressQrScannerSheet(
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
        ),
      ],
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