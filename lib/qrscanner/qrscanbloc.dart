// import 'package:bloc/bloc.dart';
// import 'package:qr_generator/qrscanner/qrscanevent.dart' show QrResetEvent, QrScanEvent, QrScannedEvent;
// import 'package:qr_generator/qrscanner/qrscanstate.dart' show QrScanState;


// class QrScanBloc extends Bloc<QrScanEvent, QrScanState> {
//   QrScanBloc() : super(QrScanState.initial()) {
//     on<QrScannedEvent>((event, emit) {
//       emit(state.copyWith(decodedData: event.scannedData));
//     });

//     on<QrResetEvent>((event, emit) {
//       emit(state.copyWith(decodedData: ""));
//     });
//   }
// }
