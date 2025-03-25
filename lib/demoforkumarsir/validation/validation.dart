import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:qr_generator/demoforkumarsir/registerpage/register.dart';
import 'package:qr_generator/locationservice/lcoationservice.dart';

class QRValidationScreen extends StatefulWidget {
  @override
  _QRValidationScreenState createState() => _QRValidationScreenState();
}

class _QRValidationScreenState extends State<QRValidationScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final box = GetStorage();
  final locationService = Get.find<LocationService>();

  bool isLoading = false;
  String? validationMessage;
  Map<String, dynamic>? userData;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    validationMessage = null;
    userData = null;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing) return;
      isProcessing = true;

      final scannedID = scanData.code ?? "";
      debugPrint("🔍 Scanned ID: $scannedID");

      if (scannedID.startsWith("S.No")) {
        controller.pauseCamera();
        await _validateQR(scannedID);
        await Future.delayed(Duration(seconds: 2));
        isProcessing = false;
      }
    });
  }

  Future<void> _validateQR(String uniqueID) async {
    debugPrint("🔍 VALIDATING uniqueID: $uniqueID");

    setState(() {
      isLoading = true;
      validationMessage = null;
      userData = null;
    });

    final savedData = box.read(uniqueID);
    debugPrint("📦 Retrieved data: $savedData");

    if (savedData == null) {
      debugPrint("❌ No data found for uniqueID: $uniqueID");
      _showRegistrationPopup(uniqueID);
      return;
    }

    final storedUID = savedData["uniqueID"];
    debugPrint("✅ Stored uniqueID inside map: $storedUID");

    final savedLat = double.parse(savedData["location"].split(", ")[0]);
    final savedLon = double.parse(savedData["location"].split(", ")[1]);

    final currentPosition = locationService.currentPosition.value;
    if (currentPosition == null) {
      setState(() {
        validationMessage = "⚠️ Unable to get current location!";
        isLoading = false;
      });
      _showResultPopup();
      return;
    }

    final distance = _calculateDistance(
      savedLat, savedLon,
      currentPosition.latitude, currentPosition.longitude,
    );

    if (distance <= 15) {
      setState(() {
        validationMessage = "🎉 Location Matched!";
        userData = savedData;
        isLoading = false;
      });
    } else {
      setState(() {
        validationMessage = "⚠️ You are outside the 15M range!";
        userData = null;
        isLoading = false;
      });
    }

    _showResultPopup();
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
        sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  void _showRegistrationPopup(String uniqueID) {
    setState(() => isLoading = false);
    Get.defaultDialog(
      title: "No Data Found!",
      middleText: "This QR Code is not registered. Do you want to register?",
      textConfirm: "Register",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.to(() => FormScreen(uniqueID: uniqueID));
      },
      onCancel: () {
        controller?.resumeCamera();
      },
    );
  }

  void _showResultPopup() {
    final size = MediaQuery.of(context).size;

    Get.defaultDialog(
      title: "",
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset(
                validationMessage!.contains("🎉")
                    ? 'assets/lottie/correct.json'
                    : 'assets/lottie/wrong.json',
                width: size.width * 0.35,
                height: size.width * 0.35,
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                validationMessage!,
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (userData != null) ...[
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Unique ID: ${userData!['uniqueID'] ?? 'N/A'}", style: TextStyle(fontSize: size.width * 0.04)),
                      Text("Mobile number: ${userData!['field1']}", style: TextStyle(fontSize: size.width * 0.04)),
                      Text("Door number: ${userData!['field2']}", style: TextStyle(fontSize: size.width * 0.04)),
                      Text("Person name: ${userData!['field3']}", style: TextStyle(fontSize: size.width * 0.04)),
                    ],
                  ),
                ),
              ],
              SizedBox(height: size.height * 0.02),
              ElevatedButton(
                onPressed: () {
                  Get.back(); // Close popup
                  controller?.resumeCamera(); // Resume scanning
                },
                child: Text("OK"),
              )
            ],
          ),
        ),
      ),
      radius: 10,
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cutOutSize = size.width * 0.7;

    return Scaffold(
      appBar: AppBar(
        title: Text("QR Validation",style: TextStyle(color: Colors.white,),),
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white,)
      ),
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
            flex: 2,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Center(
                    child: Text("Scan a QR Code to Validate",
                        style: TextStyle(fontSize: size.width * 0.045)),
                  ),
          ),
        ],
      ),
    );
  }
}
