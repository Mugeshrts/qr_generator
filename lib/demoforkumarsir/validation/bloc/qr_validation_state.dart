abstract class  QRValidationState {}

class QRInitial extends  QRValidationState {}

class QRLoading extends QRValidationState {}

class QRSuccess extends QRValidationState {
  final String message;
  final Map<String, dynamic>? userData;
  QRSuccess(this.message, this.userData);
}

class QRFailure extends QRValidationState {
  final String message;
  final String scannedID;
  QRFailure(this.message, this.scannedID);
}