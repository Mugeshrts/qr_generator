import 'package:equatable/equatable.dart';

abstract class ScannedDataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DecodeScannedData extends ScannedDataEvent {
  final String scannedData;
  DecodeScannedData(this.scannedData);

  @override
  List<Object> get props => [scannedData];
}

class ShareScannedData extends ScannedDataEvent {}

class SaveDataAsPdf extends ScannedDataEvent {}

class CopyToClipboard extends ScannedDataEvent {
  final String text;
  CopyToClipboard(this.text);

  @override
  List<Object> get props => [text];
}
