abstract class QRGeneratorEvent {}

class GenerateQRCodes extends QRGeneratorEvent {
  final int count;
  GenerateQRCodes(this.count);
}
