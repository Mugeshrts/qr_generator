import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_generator/demoforkumarsir/dashboard/dash_ui.dart';
import 'package:qr_generator/locationservice/lcoationservice.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  /// ✅ Check and Request Permissions One by One
  Future<void> _checkAndRequestPermissions() async {
    bool allGranted = await _allPermissionsGranted();

    if (allGranted) {
      _startLocationService();
      _navigateToHome();
    } else {
      await _requestPermissions();
    }
  }

  /// ✅ Check if All Permissions are Granted
  Future<bool> _allPermissionsGranted() async {
    return await Permission.camera.isGranted &&
        await Permission.location.isGranted;
  }

  /// ✅ Request Permissions One by One
  Future<void> _requestPermissions() async {
    log("Requesting Permissions");

    // Request Camera Permission
    if (!await Permission.camera.isGranted) {
      await Permission.camera.request();
    }

    // Request Location Permission
    if (!await Permission.location.isGranted) {
      await Permission.location.request();
    }

    // ✅ Check if all permissions are granted after requests
    if (await _allPermissionsGranted()) {
      log("All permissions granted");
      _startLocationService();
      _navigateToHome();
    } else {
      log("Permissions denied");
      setState(() {
        _isLoading = false; // Stop loader if permissions are denied
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please grant all permissions to continue."),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  /// ✅ Start Location Service
  void _startLocationService() async {
    Get.put(LocationService());
  }

  /// ✅ Navigate to Home Screen
  void _navigateToHome() {
    Future.delayed(Duration(seconds: 1), () {
      Get.off(() => DashboardScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "QR Code App",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
                  "Permission Required",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
          ],
        ),
      ),
    );
  }
}