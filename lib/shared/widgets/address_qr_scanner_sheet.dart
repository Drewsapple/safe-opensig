import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_opensig/shared/utils/utilities.dart';

class AddressQrScannerSheet extends StatefulWidget {
  final Function(String, String) onScanAddress;
  const AddressQrScannerSheet({super.key, required this.onScanAddress});

  @override
  State<AddressQrScannerSheet> createState() => _AddressQrScannerSheetState();
}

class _AddressQrScannerSheetState extends State<AddressQrScannerSheet> with WidgetsBindingObserver {
  final GlobalKey _qrKey = GlobalKey();
  Barcode? result;
  MobileScannerController? controller;
  bool? cameraPermissionDenied;

  void _initController() {
    controller = MobileScannerController(
      autoStart: true,
      formats: [BarcodeFormat.qrCode],
    );
    controller!.barcodes.listen((scanEvent) {
      if (!mounted) return;
      if (scanEvent.barcodes.isEmpty) return;
      var scannedData = scanEvent.barcodes.first.rawValue ?? "";
      if (scannedData.isEmpty) return;
      var address = "";
      var prefix = "";
      if (scannedData.contains(':')) {
        prefix = scannedData.split(":")[0];
        address = scannedData.split(":")[1];
      } else {
        address = scannedData;
      }
      if (Utilities.isValidAddress(address)) {
        controller!.dispose();
        Navigator.of(context).pop();
        widget.onScanAddress(address, prefix);
      }
    });
  }

  Future<void> _permissionRequest() async {
    var permissionResult = await Permission.camera.request();
    if (permissionResult.isDenied || permissionResult.isPermanentlyDenied) {
      cameraPermissionDenied = true;
    }else{
      cameraPermissionDenied = false;
    }
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _permissionRequest();
        break;
      default: break;
    }
  }

  @override
  void initState() {
    _permissionRequest();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: cameraPermissionDenied == null ? const FittedBox(
          fit: BoxFit.scaleDown,
          child: CircularProgressIndicator()
      ) : cameraPermissionDenied! ? Container(
        height: MediaQuery.of(context).size.height * 0.65,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning, size: 40, color: Colors.amber,),
            const SizedBox(height: 10,),
            const Text(
              "We need your permission to use the camera in order to be able to scan a QR Address",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20,),
            const Text(
              "You need to give this permission from the system settings",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () => openAppSettings(),
              child: Text("Open settings" ,style: TextStyle()),
            )
          ],
        ),
      ) : Builder(
        builder: (context) {
          if (controller == null){
            _initController();
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.75,
            child: MobileScanner(
              key: _qrKey,
              controller: controller,
              fit: BoxFit.cover,
            ),
          );
        }
      ),
    );
  }
}
