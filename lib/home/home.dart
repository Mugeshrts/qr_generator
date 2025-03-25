// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:qr_generator/qrscanners/qrscanner/qrscanui.dart';
// import 'package:qr_generator/grgenerator/selectfield/selectionui.dart';


// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("QR Code App", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.teal,
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton.icon(
//               onPressed: () => Get.to(() => SelectionPage()),
//               icon: Icon(Icons.qr_code),
//               label: Text("Generate QR",style: TextStyle(color: Colors.white),),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 iconColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: () => Get.to(() => QrScannerPage()),
//               icon: Icon(Icons.qr_code_scanner),
//               label: Text("Scan QR",style: TextStyle(color: Colors.white),),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 iconColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:qr_generator/home/bloc/qrhome_bloc.dart';
import 'package:qr_generator/home/bloc/qrhome_event.dart';
import 'package:qr_generator/home/bloc/qrhome_state.dart';
import 'package:qr_generator/qrscanners/qrscanner/qrscanui.dart';
import 'package:qr_generator/grgenerator/selectfield/selectionui.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is NavigateGenerator) {
            Get.to(() => SelectionPage());
          } else if (state is NavigateScanner) {
            Get.to(() => QrScannerPage());
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("QR Code App", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.teal,
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.read<HomeBloc>().add(NavigateToGenerator()),
                  icon: Icon(Icons.qr_code),
                  label: Text("Generate QR", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    iconColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => context.read<HomeBloc>().add(NavigateToScanner()),
                  icon: Icon(Icons.qr_code_scanner),
                  label: Text("Scan QR", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    iconColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
