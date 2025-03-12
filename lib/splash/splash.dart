import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_generator/home/home.dart';
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


  /// ✅ Check Permissions & Request if Not Granted
  Future<void> _checkAndRequestPermissions() async {
    if (await _allPermissionsGranted()) {
      _startLocationService(); // ✅ Start the background location service
      _navigateToHome();
    } else {
      _requestPermissions();
    }
  }

  /// ✅ Check if All Required Permissions are Granted
  Future<bool> _allPermissionsGranted() async {
    return await Permission.camera.isGranted &&
        await Permission.location.isGranted;
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

    if (await _allPermissionsGranted()) {
      _startLocationService();
      _navigateToHome();
    } else {
      setState(() {
        _isLoading = false; // ✅ Stop loader if permissions are denied
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please grant all permissions to continue.")),
      );
    }
  }


void _startLocationService() async{
  Get.put(LocationService());
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
           _isLoading 
                ? CircularProgressIndicator(color: Colors.white,)
                : Text("Permission Required", style: TextStyle(fontSize: 16, color:Colors.white)),
          ],
        ),
      ),
    );
  }
}
