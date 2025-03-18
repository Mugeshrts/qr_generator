
//state

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class LocationGranted extends SplashState {}
class LocationDenied extends SplashState {
  final String msg;
  LocationDenied({required this.msg});
}
class LocationPermanentlyDenied extends SplashState {
  final String msg;
  LocationPermanentlyDenied({required this.msg});
}

class CameraGranted extends SplashState {}
class CameraDenied extends SplashState {
  final String msg;
  CameraDenied({required this.msg});
}
class CameraPermanentlyDenied extends SplashState {
  final String msg;
  CameraPermanentlyDenied({required this.msg});
}

class SplashError extends SplashState {
  final String error;
  SplashError({required this.error});
}

class PermissionsGranted extends SplashState {}