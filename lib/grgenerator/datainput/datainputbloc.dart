import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_generator/grgenerator/datainput/datainputevent.dart';
import 'package:qr_generator/grgenerator/datainput/datainputstate.dart';
import 'package:qr_generator/locationservice/lcoationservice.dart';

class InputBloc extends Bloc<InputEvent, InputState> {
  final LocationService locationService = Get.find<LocationService>(); // Access location service
   bool _qrGenerated = false; // ✅ Flag to stop updating location after QR is generated

    InputBloc(List<String> selectedFields)
      : super(InputState(
          fieldValues: {for (var field in selectedFields) field: ""},
          isFormValid: false,
          isAccuracyValid: false,
          encryptedData: "",
        )) {
          
     on<UpdateFieldEvent>((event, emit) {
      final updatedValues = Map<String, String>.from(state.fieldValues);
      updatedValues[event.field] = event.value;
      bool formValid = updatedValues.values.any((value) => value.isNotEmpty);
      emit(state.copyWith(fieldValues: updatedValues, isFormValid: formValid, encryptedData: "", isAccuracyValid: state.isAccuracyValid));
    });


    on<GenerateQrEvent>((event, emit) {
      _qrGenerated = true; // ✅ Stop updating location after QR is generated

      String jsonData = jsonEncode(state.fieldValues);
      String encryptedData = base64Encode(utf8.encode(jsonData));

      emit(state.copyWith(encryptedData: encryptedData, isAccuracyValid: state.isAccuracyValid));
    });

     on<UpdateLocationEvent>((event, emit) {
      if (_qrGenerated) return; // ✅ Do NOT update location after QR is generated

      final updatedValues = Map<String, String>.from(state.fieldValues);
      updatedValues["Latitude"] = event.latitude;
      updatedValues["Longitude"] = event.longitude;
      updatedValues["Accuracy"] = event.accuracy;

      int accuracyValue = int.tryParse(event.accuracy) ?? 1000;
      bool accuracyValid = accuracyValue < 15;

      emit(state.copyWith(fieldValues: updatedValues, isAccuracyValid: accuracyValid, encryptedData: ""));
   
    //  if(!accuracyValid){
    //   _showAccuracyAlert();
    //  }

    });


     on<ResetQrEvent>((event, emit) {
      _qrGenerated = false; // ✅ Allow location updates again when resetting QR
      emit(state.copyWith(encryptedData: "", isAccuracyValid: state.isAccuracyValid));
    }); 


    locationService.currentPosition.listen((position) {
      if (position != null) {
        add(UpdateLocationEvent(
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
          accuracy: position.accuracy.toInt().toString(),
        ));
      }
    });
  }
    /// ✅ Show an AlertDialog with Lottie animation if accuracy is too high
  // void _showAccuracyAlert() {
  //   Get.dialog(
  //     AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Lottie.asset('assets/lottie/location.json', height: 120), // ✅ Lottie Animation
  //           const SizedBox(height: 10),
  //           const Text(
  //             "Low accuracy detected! Please move to an open area for better GPS accuracy.",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: () => Get.back(), // Close dialog
  //             child: const Text("OK"),
  //           ),
  //         ],
  //       ),
  //     ),
  //     barrierDismissible: false, // Prevents dismissing by tapping outside
  //   );
  // }
}
