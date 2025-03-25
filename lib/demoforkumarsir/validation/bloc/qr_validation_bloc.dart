// qr_validation_bloc.dart
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_generator/locationservice/lcoationservice.dart';
import 'qr_validation_event.dart';
import 'qr_validation_state.dart';

class QRValidationBloc extends Bloc<QrValidationEvent, QRValidationState> {
  final GetStorage box;
  final LocationService locationService;

  QRValidationBloc(this.box, this.locationService) : super(QRInitial()) {
    on<QRScanned>(_onQRScanned);
  }

  Future<void> _onQRScanned(QRScanned event, Emitter<QRValidationState> emit) async {
    emit(QRLoading());

    final uniqueID = event.scannedID;
    final savedData = box.read(uniqueID);

    if (savedData == null) {
      emit(QRFailure("No Data Found", uniqueID));
      return;
    }

    final savedLat = double.parse(savedData["location"].split(", ")[0]);
    final savedLon = double.parse(savedData["location"].split(", ")[1]);

    final currentPosition = locationService.currentPosition.value;
    if (currentPosition == null) {
      emit(QRSuccess("⚠️ Unable to get current location!", null));
      return;
    }

    final distance = _calculateDistance(
      savedLat, savedLon,
      currentPosition.latitude, currentPosition.longitude,
    );

    if (distance <= 15) {
      emit(QRSuccess("🎉 Location Matched!", savedData));
    } else {
      emit(QRSuccess("⚠️ You are outside the 15M range!", null));
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
        sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }
}
