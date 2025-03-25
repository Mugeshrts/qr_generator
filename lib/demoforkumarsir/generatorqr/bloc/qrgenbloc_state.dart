abstract class QRGeneratorState {}

class QRInitial extends QRGeneratorState {}

class QRGenerating extends QRGeneratorState {}

class QRGenerated extends QRGeneratorState {
  final List<String> codes;
  QRGenerated(this.codes);
}
