import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_generator/home/home.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  /// Request All Permissions
  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      // Permission.storage,
      // Permission.manageExternalStorage,
      Permission.location,
      // Permission.photos,
    ].request();

    if (statuses.values.every((status) => status.isGranted)) {
      _navigateToHome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please grant all permissions to continue.")),
      );
    }
  }

  /// Navigate to Home Screen
  void _navigateToHome() {
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => HomeScreen());
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
            Text("QR Code App", style: TextStyle(fontSize: 24, color: Colors.white)),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
