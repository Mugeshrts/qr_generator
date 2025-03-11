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
          encryptedData: " ",
        )) {
          
    on<UpdateFieldEvent>((event, emit) {
      final updatedValues = Map<String, String>.from(state.fieldValues);
      updatedValues[event.field] = event.value;
      // Check if at least one field has data
      bool formValid = updatedValues.values.any((value) => value.isNotEmpty);
      emit(state.copyWith(fieldValues: updatedValues, isFormValid: formValid, encryptedData: ''));
    });

    on<SubmitFormEvent>((event, emit) {
      print("Submitted Data: ${state.fieldValues}");
    });

    on<GenerateQrEvent>((event, emit) {
      // Convert data to JSON, then encode to Base64
      String jsonData = jsonEncode(state.fieldValues);
      String encryptedData = base64Encode(utf8.encode(jsonData));

      emit(state.copyWith(encryptedData: encryptedData));
    });

 on<UpdateLocationEvent>((event, emit) {
      final updatedValues = Map<String, String>.from(state.fieldValues);
      updatedValues["Latitude"] = event.latitude;
      updatedValues["Longitude"] = event.longitude;
      updatedValues["Accuracy"] = event.accuracy;

      emit(state.copyWith(fieldValues: updatedValues, encryptedData: state.encryptedData));
    });


 on<ResetQrEvent>((event, emit) {
      emit(state.copyWith(encryptedData: "")); // Reset QR state
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