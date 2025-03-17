import 'package:equatable/equatable.dart';

class InputState extends Equatable {
  final Map<String, String> fieldValues;
  final bool isFormValid;
  final bool isAccuracyValid;
  final String encryptedData;

  const InputState({
    required this.fieldValues,
    required this.isFormValid,
    this.encryptedData = "",
    required this.isAccuracyValid,
  });

  InputState copyWith({Map<String, String>? fieldValues, bool? isFormValid, String? encryptedData, bool? isAccuracyValid}) {
    return InputState(
      fieldValues: fieldValues ?? this.fieldValues,
      isFormValid: isFormValid ?? this.isFormValid,
      encryptedData: encryptedData ?? this.encryptedData, 
      isAccuracyValid: isAccuracyValid ?? this.isAccuracyValid,
    );
  }

  @override
  List<Object> get props => [fieldValues, isFormValid, encryptedData, isAccuracyValid];
}
