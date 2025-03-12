// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:qr_generator/qrscanners/decodeddata/decodeddata.dart';
// // import 'package:qr_generator/scanner/scanned_data_page.dart';

// class QrScannerPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("QR scanner",style: TextStyle(color: Colors.white),),
//      backgroundColor: Colors.teal,
//      iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: Stack(
//         children: [
//           MobileScanner(
//           //  allowDuplicates: false,
//             onDetect: (capture) {
//               final List<Barcode> barcodes = capture.barcodes;
//               if (barcodes.isNotEmpty) {
//                 final String scannedData = barcodes.first.rawValue ?? "No Data Found";
//                 Get.off(() => ScannedDataPage(scannedData: scannedData)); // Navigate to result screen
//               }
//             },
//           ),

//           // Scanner Overlay
//           Center(
//             child: Container(
//               width: 250,
//               height: 250,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.teal, width: 3),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),

//           // Scanner Instructions
//           Positioned(
//             bottom: 60,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Text(
//                 "Align the QR code within the frame",
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_generator/locationservice/lcoationservice.dart';
import 'package:qr_generator/qrscanners/decodeddata/decodeddata.dart';


class QrScannerPage extends StatefulWidget {
  @override
  _QrScannerPageState createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final LocationService locationService = Get.find<LocationService>();
  bool isProcessing = false; // ✅ Prevents duplicate scans

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) async {
              if (isProcessing) return; // ✅ Prevent duplicate scans
              isProcessing = true;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String scannedData = barcodes.first.rawValue ?? "No Data Found";

                try {
                  // ✅ Decode JSON safely
                  Map<String, dynamic> decodedData = jsonDecode(utf8.decode(base64Decode(scannedData)));

                  if (decodedData.containsKey("Latitude") && decodedData.containsKey("Longitude")) {
                    double scannedLat = double.tryParse(decodedData["Latitude"]) ?? 0.0;
                    double scannedLng = double.tryParse(decodedData["Longitude"]) ?? 0.0;

                    // ✅ Get the current location
                    Position? currentPosition = locationService.currentPosition.value;
                    if (currentPosition != null) {
                      double distanceInMeters = Geolocator.distanceBetween(
                        scannedLat, scannedLng, 
                        currentPosition.latitude, currentPosition.longitude,
                      );

                      if (distanceInMeters > 5) {
                        _showDistancePopup(context, distanceInMeters); // ✅ Show pop-up if user is too far
                      } else {
                        Get.off(() => ScannedDataPage(scannedData: scannedData)); // ✅ Navigate if valid
                      }
                    } else {
                      _showSnackbar("Location Error", "Could not get current location.");
                    }
                  } else {
                    _showSnackbar("Invalid QR", "Location data not found in QR code.");
                  }
                } catch (e) {
                  _showSnackbar("Invalid QR", "QR Code data is not in the correct format.");
                }
              }

              await Future.delayed(Duration(seconds: 2)); // ✅ Prevents immediate rescan
              isProcessing = false; // ✅ Reset flag
            },
          ),

          // Scanner Overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Scanner Instructions
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                "Align the QR code within the frame",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Show pop-up for distance mismatch
  void _showDistancePopup(BuildContext context, double distance) {
    if (mounted) {
      Get.defaultDialog(
        title: "Location Mismatch",
        middleText: "You are ${distance.toStringAsFixed(2)} meters away from the scanned location.",
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () => Get.back(),
      );
    }
  }

  // ✅ Show snackbar only once per scan
  void _showSnackbar(String title, String message) {
    if (mounted) {
      Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
