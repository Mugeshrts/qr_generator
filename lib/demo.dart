// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:qr_generator/locationservice/lcoationservice.dart';


// class LocationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final locationService = Get.find<LocationService>(); // Ensure it's registered

//     return Scaffold(
//       appBar: AppBar(title: Text('Live Location Tracker')),
//       body: Center(
//         child: Obx(() {
//           final position = locationService.currentPosition.value;
//           return position != null
//               ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('LatLong: ${position.latitude}, ${position.longitude}'),
//                     // Text('Longitude: ${position.longitude}'),
//                     Text('Accuracy: ${position.accuracy.toInt()}M')
//                   ],
//                 )
//               : Text('Fetching location...');
//         }),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => locationService.startTracking(),
//         child: Icon(Icons.location_on),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_generator/home/home.dart';


class PermissionHelper {
  static Future<bool> requestPermission(Permission permission) async {
    print("Requesting ${permission.toString()}...");
    
    PermissionStatus status = await permission.request();
    
    print("${permission.toString()} Status: $status");

    if (status == PermissionStatus.permanentlyDenied) {
      print("Permission permanently denied! Opening settings...");
      openAppSettings(); // Opens app settings if permission is permanently denied
      return false;
    }

    return status.isGranted;
  }

  static Future<bool> requestCameraPermission() => requestPermission(Permission.camera);

  static Future<bool> requestLocationPermission() => requestPermission(Permission.location);
}



class SplashScreen1 extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

 Future<void> _checkPermissions() async {
  print("Requesting Camera Permission...");
  bool cameraGranted = await PermissionHelper.requestCameraPermission();
  print("Camera Permission: $cameraGranted");

  await Future.delayed(Duration(milliseconds: 500)); // Avoid multiple requests at once

  print("Requesting Location Permission...");
  bool locationGranted = await PermissionHelper.requestLocationPermission();
  print("Location Permission: $locationGranted");

  await Future.delayed(Duration(seconds: 2)); // Simulating splash duration

  if (cameraGranted && locationGranted) {
    print("All permissions granted. Navigating to HomeScreen.");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  } else {
    print("Permissions denied. Showing dialog or handling UI.");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Loading...",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}