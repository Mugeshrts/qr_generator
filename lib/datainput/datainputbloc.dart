// Bloc
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:qr_generator/datainput/datainputevent.dart';
import 'package:qr_generator/datainput/datainputstate.dart';

class InputBloc extends Bloc<InputEvent, InputState> {
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

 on<ResetQrEvent>((event, emit) {
      emit(state.copyWith(encryptedData: "")); // Reset QR state
    });

  }
}