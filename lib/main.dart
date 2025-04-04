import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_generator/demo.dart';
import 'package:qr_generator/grgenerator/selectfield/selectionbloc.dart';
import 'package:qr_generator/locationservice/lcoationservice.dart';
import 'package:qr_generator/qrscanners/decodeddata/bloc/decodeddata_bloc.dart';



void startBackgroundService() async {
  await Future.delayed(Duration(seconds: 2));

  // Start location tracking
  LocationService locationService = Get.find<LocationService>();
  locationService.startTracking();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // // Register LocationService
  // Get.put(LocationService()); 

  //  // Register LocationService in GetX
  // Get.put(LocationService());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SelectionBloc()),
        BlocProvider(create: (context) => ScannedDataBloc()), // ✅ Provide Bloc
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
