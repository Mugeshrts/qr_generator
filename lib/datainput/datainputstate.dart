// State
import 'package:equatable/equatable.dart';

class InputState extends Equatable {
  final Map<String, String> fieldValues;
  final bool isFormValid;
  final String encryptedData; // Encrypted Base64 string

   const InputState({required this.fieldValues, required this.isFormValid, this.encryptedData = ""});

  InputState copyWith({Map<String, String>? fieldValues, bool? isFormValid, required String encryptedData}) {
     return InputState(
      fieldValues: fieldValues ?? this.fieldValues,
      isFormValid: isFormValid ?? this.isFormValid,
       encryptedData: encryptedData ?? this.encryptedData, // **Ensures a valid String**
    );
  }

  @override
   List<Object> get props => [fieldValues, isFormValid, encryptedData];
}