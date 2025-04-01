abstract class QRGeneratorState {}

class QRInitial extends QRGeneratorState {}

class QRGenerating extends QRGeneratorState {}

class QRGenerated extends QRGeneratorState {
  final List<String> codes;
  QRGenerated(this.codes);
}


class QRError extends QRGeneratorState {  // 🔹 Add this new state
  final String message;
  QRError(this.message);
}