// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:qr_generator/demo.dart';
// import 'package:qr_generator/locationservice/lcoationservice.dart';
// import 'package:qr_generator/grgenerator/selectfield/selectionbloc.dart';
// import 'package:qr_generator/splash/splash.dart';
// import 'package:qr_generator/locationservice/background_service.dart';

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   Future.delayed(Duration(seconds: 2), () async {
//     await BackgroundService.initializeService();
//   });
//   // await GetStorage.init();
//    Get.put(LocationService());
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => SelectionBloc()),
//        // BlocProvider(create: (context) => QrScanBloc()),
//       ],
//       child: GetMaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: HomeScreen1(),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_generator/grgenerator/selectfield/selectionbloc.dart';
import 'package:qr_generator/locationservice/lcoationservice.dart';
import 'package:qr_generator/splash/splash.dart';


void startBackgroundService() async {
  await Future.delayed(Duration(seconds: 2));

  // Start location tracking
  LocationService locationService = Get.find<LocationService>();
  locationService.startTracking();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Register LocationService
  Get.put(LocationService()); 

   // Register LocationService in GetX
  Get.put(LocationService());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SelectionBloc()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
