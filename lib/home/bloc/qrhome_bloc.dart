import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_generator/home/bloc/qrhome_event.dart';
import 'package:qr_generator/home/bloc/qrhome_state.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState>{
  HomeBloc() : super(HomeInitial()){
    on<NavigateToGenerator>((event, emit) => emit(NavigateGenerator()));
    on<NavigateToScanner>((event, emit) => emit(NavigateScanner()));
  }
}