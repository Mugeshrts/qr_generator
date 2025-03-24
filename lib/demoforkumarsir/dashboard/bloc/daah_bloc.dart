import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_generator/demoforkumarsir/dashboard/bloc/daah_event.dart';
import 'package:qr_generator/demoforkumarsir/dashboard/bloc/daah_state.dart';


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>((event, emit) {
      emit(DashboardLoaded()); // 🚀 Directly emit loaded state
    });
  }
}
