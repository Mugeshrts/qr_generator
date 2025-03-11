import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


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
      currentPosition.value = position;

      // Convert accuracy to integer
      int accuracyInt = position.accuracy.toInt();

      print('Updated Location: Lat: ${position.latitude}, Lng: ${position.longitude}');
      print("Accuracy: ${accuracyInt}M");
    });
  }

  void stopTracking() {
    _timer?.cancel();
  }
}