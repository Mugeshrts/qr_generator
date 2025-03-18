import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_generator/locationservice/lcoationservice.dart';
import 'package:qr_generator/qrscanners/decodeddata/bloc/decodeddata.dart';

class QrScannerPage extends StatefulWidget {
  @override
  _QrScannerPageState createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final LocationService locationService = Get.find<LocationService>();
  bool isProcessing = false; // ✅ Prevents duplicate scans
  GoogleMapController? _mapController;

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
                final String scannedData =
                    barcodes.first.rawValue ?? "No Data Found";

                try {
                  // ✅ Decode JSON safely
                  Map<String, dynamic> decodedData = jsonDecode(
                    utf8.decode(base64Decode(scannedData)),
                  );

                  if (decodedData.containsKey("Latitude") &&
                      decodedData.containsKey("Longitude")) {
                    double scannedLat =
                        double.tryParse(decodedData["Latitude"]) ?? 0.0;
                    double scannedLng =
                        double.tryParse(decodedData["Longitude"]) ?? 0.0;

                    // ✅ Get the current location
                    Position? currentPosition =
                        locationService.currentPosition.value;
                    if (currentPosition != null) {
                      double distanceInMeters = Geolocator.distanceBetween(
                        scannedLat,
                        scannedLng,
                        currentPosition.latitude,
                        currentPosition.longitude,
                      );

                      if (distanceInMeters > 15) {
                        _showDistancePopup(
                          context,
                          distanceInMeters,
                        ); // ✅ Show pop-up if user is too far
                      } else {
                        Get.off(
                          () => ScannedDataPage(scannedData: scannedData),
                        ); // ✅ Navigate if valid
                      }
                    } else {
                      _showSnackbar(
                        "Location Error",
                        "Could not get current location.",
                      );
                    }
                  } else {
                    _showSnackbar(
                      "Invalid QR",
                      "Location data not found in QR code.",
                    );
                  }
                } catch (e) {
                  _showSnackbar(
                    "Invalid QR",
                    "QR Code data is not in the correct format.",
                  );
                }
              }

              await Future.delayed(
                Duration(seconds: 2),
              ); // ✅ Prevents immediate rescan
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
                "",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),

          Positioned(
            bottom: 70,
            left: 20,
            right: 20,
            child: Obx(() {
              Position? position =
                  locationService.currentPosition.value; // ✅ FIXED

              if (position == null) {
                return Center(
                  child: Text(
                    "Fetching location...",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }

              String lat = position.latitude.toStringAsFixed(6);
              String lng = position.longitude.toStringAsFixed(6);
              String accuracy = "${position.accuracy.toInt()}M";

              return Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ✅ Mini-Map (Left Side)
                    Container(
                      height: 100,
                      width: 100, // ✅ Fixed width to keep map small
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              position.latitude,
                              position.longitude,
                            ),
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId("current_location"),
                              position: LatLng(
                                position.latitude,
                                position.longitude,
                              ),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueAzure,
                              ),
                            ),
                          },
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                          },
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: true,
                        ),
                      ),
                    ),

                    SizedBox(width: 12), // ✅ Space between Map & Text
                    // ✅ Text (Right Side)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "📍 Latitude: $lat",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "📍 Longitude: $lng",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "🎯 Accuracy: $accuracy",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ✅ Show pop-up for distance mismatch
  void _showDistancePopup(BuildContext context, double distance) {
    if (mounted) {
      Get.defaultDialog(
        titlePadding: EdgeInsets.all(10),
        contentPadding: EdgeInsets.all(10),
        title: "${distance.toStringAsFixed(0)} Meter away",
        titleStyle: TextStyle(
          color: const Color.fromARGB(255, 202, 19, 6),
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        middleText: "You are away from the registered QR location.",
        middleTextStyle: TextStyle(fontSize: 20),
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
