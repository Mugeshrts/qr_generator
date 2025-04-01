import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_generator/demoforkumarsir/generatorqr/bloc/qrgenbloc_event.dart';
import 'package:qr_generator/demoforkumarsir/generatorqr/bloc/qrgenbloc_state.dart';
import 'package:qr_generator/demoforkumarsir/localdatabase/databasehelper.dart';

class QRGeneratorBloc extends Bloc<QRGeneratorEvent, QRGeneratorState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  QRGeneratorBloc() : super(QRInitial()) {
    on<GenerateQRCodes>(_onGenerateQRCodes);
    on<LoadSavedQRCodes>(_onLoadSavedQRCodes);
  }

  Future<void> _onGenerateQRCodes(
      GenerateQRCodes event, Emitter<QRGeneratorState> emit) async {
    emit(QRGenerating());

    await Future.delayed(Duration(seconds: 2));

    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    final random = Random();
    Set<String> uniqueCodes = {};
    final database = DatabaseHelper.instance;

    // ✅ 1. Clear existing QR codes
  await database.deleteAllQRs();
  print("🗑️ Deleted old QR codes from database.");

    try {
      final existingCodes = await _databaseHelper.getAllQRs();
      print("ℹ️ Existing QR Codes in DB: $existingCodes");

      while (uniqueCodes.length < event.count) {
        String newCode = letters[random.nextInt(letters.length)] +
            numbers[random.nextInt(numbers.length)] +
            letters[random.nextInt(letters.length)] +
            numbers[random.nextInt(numbers.length)];

        if (!existingCodes.contains(newCode)) {
          uniqueCodes.add(newCode);
          await _databaseHelper.insertQR(newCode);
        }
      }

      final codes = uniqueCodes.toList();
      print("✅ Successfully generated QR Codes: $codes");
      emit(QRGenerated(codes));
    } catch (e) {
      print("❌ Error generating QR codes: $e");
      emit(QRError("Failed to generate QR codes."));
    }
  }

  Future<void> _onLoadSavedQRCodes(
      LoadSavedQRCodes event, Emitter<QRGeneratorState> emit) async {
    emit(QRGenerating());

    try {
      final savedCodes = await _databaseHelper.getAllQRs();
      print("📂 Successfully loaded QR codes from DB: $savedCodes");
      emit(QRGenerated(savedCodes));
    } catch (e) {
      print("❌ Error loading saved QR codes: $e");
      emit(QRError("Failed to load saved QR codes."));
    }
  }
}
