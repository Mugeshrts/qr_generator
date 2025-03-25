import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:qr_generator/demoforkumarsir/registerpage/register.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
  this.controller = controller;
  controller.scannedDataStream.listen((scanData) {
    String scannedID = scanData.code ?? ""; // Get scanned QR ID
    if (scannedID.startsWith("S.No")) { // Ensure it's a valid QR format
      controller.pauseCamera();
      
      final box = GetStorage();
      final existingData = box.read(scannedID); // Check if data exists
      
      if (existingData != null) {
        _showAlreadyRegisteredPopup(scannedID);
      } else {
        Get.to(() => FormScreen(uniqueID: scannedID));
      }
    }
  });
}

/// ✅ Show Popup if QR Code is Already Registered
void _showAlreadyRegisteredPopup(String uniqueID) {
  Get.defaultDialog(
    title: "Already Registered",
    middleText: "This QR Code is already registered. What do you want to do?",
    textConfirm: "View Details",
    textCancel: "Cancel",
    confirmTextColor: Colors.white,
    onConfirm: () {
      Get.back(); // Close popup
      Get.to(() => FormScreen(uniqueID: uniqueID)); // Open form with saved data
    },
    onCancel: () {
      controller?.resumeCamera(); // Resume scanning
    },
  );
}

  @override
  Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final cutOutSize = size.width * 0.7;

    return Scaffold(
      appBar: AppBar(title: Text("Scan QR Code",style: TextStyle(color: Colors.white),), backgroundColor: Colors.teal, iconTheme: IconThemeData(color: Colors.white),),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
               overlay: QrScannerOverlayShape(
                borderColor: Colors.teal,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: cutOutSize,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(child: Text("Scan a QR Code to proceed")),
          ),
        ],
      ),
    );
  }
}
