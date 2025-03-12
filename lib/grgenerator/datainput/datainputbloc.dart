// Bloc
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:qr_generator/grgenerator/datainput/datainputevent.dart';
import 'package:qr_generator/grgenerator/datainput/datainputstate.dart';
import 'package:qr_generator/locationservice/lcoationservice.dart';

class InputBloc extends Bloc<InputEvent, InputState> {
     final LocationService locationService = Get.find<LocationService>(); // Access location service

  InputBloc(List<String> selectedFields)
      : super(InputState(
          fieldValues: {for (var field in selectedFields) field: ""},
          isFormValid: false,
          isAccuracyValid: false, // ✅ New field for accuracy validation
          encryptedData: " ",
        )) {
          
    on<UpdateFieldEvent>((event, emit) {
      final updatedValues = Map<String, String>.from(state.fieldValues);
      updatedValues[event.field] = event.value;
      // Check if at least one field has data
      bool formValid = updatedValues.values.any((value) => value.isNotEmpty);
      emit(state.copyWith(fieldValues: updatedValues, isFormValid: formValid, encryptedData: '', isAccuracyValid: state.isAccuracyValid));
    });

    on<SubmitFormEvent>((event, emit) {
      print("Submitted Data: ${state.fieldValues}");
    });

    on<GenerateQrEvent>((event, emit) {
      // Convert data to JSON, then encode to Base64
      String jsonData = jsonEncode(state.fieldValues);
      String encryptedData = base64Encode(utf8.encode(jsonData));

      emit(state.copyWith(encryptedData: encryptedData, isAccuracyValid: state.isAccuracyValid ));
    });

 on<UpdateLocationEvent>((event, emit) {
      final updatedValues = Map<String, String>.from(state.fieldValues);
      updatedValues["Latitude"] = event.latitude;
      updatedValues["Longitude"] = event.longitude;
      updatedValues["Accuracy"] = event.accuracy;

      // ✅ Enable button only if accuracy < 20M
      // int accuracyValue = int.tryParse(event.accuracy) ?? 1000; // Default to high value if parsing fails
      bool accuracyValid = int.parse(event.accuracy) < 15;

      // print("📏 Checking Accuracy: ${accuracyValue}M (Valid: $accuracyValid)"); // ✅ Debugging output


      emit(state.copyWith(
        fieldValues: updatedValues, 
        isAccuracyValid: accuracyValid, encryptedData: '', // ✅ Update accuracy validation state
      ));
    });


 on<ResetQrEvent>((event, emit) {
      emit(state.copyWith(encryptedData: "", isAccuracyValid: state.isAccuracyValid)); // Reset QR state
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
}