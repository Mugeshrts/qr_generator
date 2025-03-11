import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_generator/locationservice/lcoationservice.dart';


class LocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationService = Get.find<LocationService>(); // Ensure it's registered

    return Scaffold(
      appBar: AppBar(title: Text('Live Location Tracker')),
      body: Center(
        child: Obx(() {
          final position = locationService.currentPosition.value;
          return position != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('LatLong: ${position.latitude}, ${position.longitude}'),
                    // Text('Longitude: ${position.longitude}'),
                    Text('Accuracy: ${position.accuracy.toInt()}M')
                  ],
                )
              : Text('Fetching location...');
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => locationService.startTracking(),
        child: Icon(Icons.location_on),
      ),
    );
  }
}


