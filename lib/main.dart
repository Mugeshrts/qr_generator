import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_generator/home/home.dart';
import 'package:qr_generator/qrscanner/qrscanbloc.dart';
import 'package:qr_generator/qrscanner/qrscanui.dart';
import 'package:qr_generator/selectfield/selectionbloc.dart';
import 'package:qr_generator/selectfield/selectionui.dart';
import 'package:qr_generator/splash/splash.dart';

void main() async{
  // WidgetsFlutterBinding.ensureInitialized(); // Ensure plugins are initialized
  // await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SelectionBloc()),
       // BlocProvider(create: (context) => QrScanBloc()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

