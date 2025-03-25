abstract class QrValidationEvent {}

class QRScanned extends QrValidationEvent {
  final String scannedID;
  QRScanned(this.scannedID);
}