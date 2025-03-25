import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_generator/demoforkumarsir/generatorqr/bloc/qrgenbloc_event.dart';
import 'package:qr_generator/demoforkumarsir/generatorqr/bloc/qrgenbloc_state.dart';


class QRGeneratorBloc extends Bloc<QRGeneratorEvent, QRGeneratorState> {
  QRGeneratorBloc() : super(QRInitial()) {
    on<GenerateQRCodes>(_onGenerateQRCodes);
  }

  FutureOr<void> _onGenerateQRCodes(
      GenerateQRCodes event, Emitter<QRGeneratorState> emit) async {
    emit(QRGenerating());

    await Future.delayed(Duration(seconds: 2)); // Simulate Lottie delay

    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    final random = Random();
    Set<String> uniqueCodes = {};

    while (uniqueCodes.length < event.count) {
      String newCode =
          letters[random.nextInt(letters.length)] +
          numbers[random.nextInt(numbers.length)] +
          letters[random.nextInt(letters.length)] +
          numbers[random.nextInt(numbers.length)];
      uniqueCodes.add(newCode);
    }

    final codes = uniqueCodes.toList().asMap().entries.map((entry) {
      return "S.No: ${entry.key + 1}, ID: ${entry.value}";
    }).toList();

    emit(QRGenerated(codes));
  }
}
