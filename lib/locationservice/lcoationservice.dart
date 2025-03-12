import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';


class LocationService extends GetxService {
  Rx<Position?> currentPosition = Rx<Position?>(null);



  Timer? _timer;

 @override
  void onInit() {
    super.onInit();
    startTracking(); // Start tracking automatically
  }

  Future<void> startTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied.');
        return;
      }
    }

     // Start periodic location updates every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      // Check if the location is mocked (Fake GPS)
      if (position.isMocked) {
        print('⚠️ Mocked Location Detected! Stopping location updates.');
        stopTracking();
        _showMockedLocationPopup();
        return;
      }

      currentPosition.value = position;
      currentPosition.refresh(); // ✅ Force UI refresh

      // Convert accuracy to integer
      int accuracyInt = position.accuracy.toInt();

      print('📍 Updated Location: Lat: ${position.latitude}, Lng: ${position.longitude}');
      print("🎯 Accuracy: ${accuracyInt}M");
    });
  }


  void stopTracking() {
    _timer?.cancel();
  }

 /// Show Popup if Fake GPS is Detected
  void _showMockedLocationPopup() {
    Get.dialog(
      AlertDialog(
        title: Text("Warning"),
        content: Text("Mocked (Fake) Location detected! Please disable Fake GPS."),
        actions: [
          TextButton(
            onPressed: (){
              exit(0);
            },
            child: Text("Close App",style: TextStyle(color: Colors.red),),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

}