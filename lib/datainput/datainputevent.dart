// Events
import 'package:equatable/equatable.dart';

abstract class InputEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateFieldEvent extends InputEvent {
  final String field;
  final String value;
  UpdateFieldEvent(this.field, this.value);

  @override
  List<Object> get props => [field, value];
}

class SubmitFormEvent extends InputEvent {}
class GenerateQrEvent extends InputEvent {}
class ResetQrEvent extends InputEvent {} // Event to reset QR state