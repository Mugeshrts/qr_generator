import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_generator/selectfield/selectionbloc.dart';
import 'package:qr_generator/selectfield/selectionui.dart';

void main() async{
  // WidgetsFlutterBinding.ensureInitialized(); // Ensure plugins are initialized
  // await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectionBloc(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SelectionPage(),
      ),
    );
  }
}
