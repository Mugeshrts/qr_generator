import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_generator/qrscanners/decodeddata/decodeddata.dart';
// import 'package:qr_generator/scanner/scanned_data_page.dart';

class QrScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR scanner",style: TextStyle(color: Colors.white),),
     backgroundColor: Colors.teal,
     iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          MobileScanner(
          //  allowDuplicates: false,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String scannedData = barcodes.first.rawValue ?? "No Data Found";
                Get.off(() => ScannedDataPage(scannedData: scannedData)); // Navigate to result screen
              }
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
            child: Center(
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
}