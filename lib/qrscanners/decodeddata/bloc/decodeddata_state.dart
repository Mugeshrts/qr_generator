import 'package:equatable/equatable.dart';

abstract class ScannedDataState extends Equatable {
  @override
  List<Object> get props => [];
}

class ScannedDataInitial extends ScannedDataState {}

class ScannedDataLoaded extends ScannedDataState {
  final Map<String, String> decodedFields;
  ScannedDataLoaded(this.decodedFields);

  @override
  List<Object> get props => [decodedFields];
}

class ScannedDataSaving extends ScannedDataState {}

class ScannedDataSaved extends ScannedDataState {
  final String filePath;
  ScannedDataSaved(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class ScannedDataError extends ScannedDataState {
  final String message;
  ScannedDataError(this.message);

  @override
  List<Object> get props => [message];
}
