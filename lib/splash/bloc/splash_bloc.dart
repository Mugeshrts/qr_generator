import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_generator/splash/bloc/splash_state.dart';
part 'splash_event.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashStarted>((event, emit) async {
      print("🔄 Checking location & camera permissions...");

      emit(SplashLoading());

      // Check initial status
      final locationStatus = await Permission.locationWhenInUse.status;
      final cameraStatus = await Permission.camera.status;

      // ✅ Request permission if denied
      if (locationStatus.isDenied) {
        final newStatus = await Permission.locationWhenInUse.request();
        if (!newStatus.isGranted) {
          print("❌ Location permission denied.");
          emit(LocationDenied(msg: "Location permission required."));
          return;
        }
      }

      if (cameraStatus.isDenied) {
        final camNewStatus = await Permission.camera.request();
        if (!camNewStatus.isGranted) {
          print("❌ Camera permission denied.");
          emit(CameraDenied(msg: "Camera permission required."));
          return;
        }
      }

      // ✅ Handle permanently denied case
      if (locationStatus.isPermanentlyDenied) {
        print("⚠️ Location permission permanently denied! Redirecting to settings.");
        openAppSettings();
        emit(LocationPermanentlyDenied(msg: "Location permission permanently denied."));
        return;
      }

      if (cameraStatus.isPermanentlyDenied) {
        print("⚠️ Camera permission permanently denied! Redirecting to settings.");
        openAppSettings();
        emit(CameraPermanentlyDenied(msg: "Camera permission permanently denied."));
        return;
      }

      // ✅ If permissions granted, move to next state
      if (locationStatus.isGranted && cameraStatus.isGranted) {
        print("✅ Both Location & Camera permissions granted.");
        await Future.delayed(Duration(seconds: 1)); // Simulate splash delay
        emit(PermissionsGranted());
      }
    });
  }
}
