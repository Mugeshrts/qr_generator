import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_generator/demoforkumarsir/dashboard/dash_ui.dart';
import 'package:qr_generator/locationservice/lcoationservice.dart';

class FormScreen extends StatefulWidget {
  final String uniqueID;

  FormScreen({required this.uniqueID});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final box = GetStorage();
  final locationService = Get.find<LocationService>();

  final TextEditingController field1Controller = TextEditingController();
  final TextEditingController field2Controller = TextEditingController();
  final TextEditingController field3Controller = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();

    ever(locationService.currentPosition, (position) {
      if (position != null) {
        locationController.text = "${position.latitude}, ${position.longitude}";
      }
    });
  }

  void _loadSavedData() {
    final savedData = box.read(widget.uniqueID);
    if (savedData != null) {
      field1Controller.text = savedData["field1"] ?? "";
      field2Controller.text = savedData["field2"] ?? "";
      field3Controller.text = savedData["field3"] ?? "";
      locationController.text = savedData["location"] ?? "";
    }
  }

  void _saveData() {
     debugPrint("💾 Saving data for uniqueID: ${widget.uniqueID}");
    if (field1Controller.text.isEmpty ||
        field2Controller.text.isEmpty ||
        field3Controller.text.isEmpty ||
        locationController.text.isEmpty) {
       showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/lottie/wrong.json', height: 100, repeat: false),
                SizedBox(height: 10),
                Text("Error", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                Text("Please fill in all fields before saving.", textAlign: TextAlign.center),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text("OK"),
                ),
              ],
            ),
          ),
        );
      },
    );
      return;
    }

   final data = {
    "uniqueID": widget.uniqueID,
    "field1": field1Controller.text,
    "field2": field2Controller.text,
    "field3": field3Controller.text,
    "location": locationController.text,
  };

 debugPrint("📦 Writing data: $data");


    box.write(widget.uniqueID, {
      "uniqueID": widget.uniqueID,
      "field1": field1Controller.text,
      "field2": field2Controller.text,
      "field3": field3Controller.text,
      "location": locationController.text,
    });

    showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/correct.json', height: 100, repeat: false),
              SizedBox(height: 10),
              Text("Success", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
              Text("Data registered for ${widget.uniqueID}", textAlign: TextAlign.center),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: Text("OK"),
              ),
            ],
          ),
        ),
      );
    },
  );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.offAll(() => DashboardScreen()),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: widget.uniqueID),
              decoration: InputDecoration(labelText: "Unique ID"),
              readOnly: true,
            ),
            SizedBox(height: 15),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: "Location (Lat, Lon)"),
              readOnly: true,
            ),
            SizedBox(height: 15),
            TextField(
              controller: field2Controller,
              decoration: InputDecoration(labelText: "Door number"),
            ),
            SizedBox(height: 15),
            TextField(
              controller: field3Controller,
              decoration: InputDecoration(labelText: "Person name"),
            ),
            SizedBox(height: 15),
            TextField(
              controller: field1Controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(labelText: "Mobile"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveData, child: Text("Register")),
          ],
        ),
      ),
    );
  }
}
