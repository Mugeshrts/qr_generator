// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:lottie/lottie.dart';

// class QRGeneratorScreen1 extends StatefulWidget {
//   @override
//   _QRGeneratorScreen1State createState() => _QRGeneratorScreen1State();
// }

// class _QRGeneratorScreen1State extends State<QRGeneratorScreen1> {
//   List<String> qrCodes = [];
//   bool isGenerating = false;

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () => _askLimitDialog());
//   }

  // / ✅ Ask user for how many QR codes to generate
//   void _askLimitDialog() {
//     final TextEditingController limitController = TextEditingController(
//       text: "10",
//     );

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (_) => AlertDialog(
//             title: Text("Enter number of QR codes (1–99)"),
//             content: TextField(
//               controller: limitController,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 LengthLimitingTextInputFormatter(2),
//                 FilteringTextInputFormatter.digitsOnly,
//               ],
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 // hintText: "e.g. 5",
//               ),
//             ),
//             actions: [
//               ElevatedButton(
//                 onPressed: () {
//                   final input = int.tryParse(limitController.text);
//                   if (input == null || input < 1 || input > 99) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text("Please enter a number between 1 and 99"),
//                       ),
//                     );
//                     return;
//                   }
//                   Navigator.pop(context);
//                   _generateQRCodes(input);
//                 },
//                 child: Text("Generate"),
//               ),
//             ],
//           ),
//     );
//   }

//   /// ✅ Generate QR Codes based on selected count
//   void _generateQRCodes(int limit) async {
//     setState(() => isGenerating = true);

//     await Future.delayed(Duration(seconds: 2)); // Simulate delay for Lottie

//     const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
//     const numbers = '0123456789';
//     final random = Random();
//     Set<String> uniqueCodes = {};

//     while (uniqueCodes.length < limit) {
//       String newCode =
//           letters[random.nextInt(letters.length)] +
//           numbers[random.nextInt(numbers.length)] +
//           letters[random.nextInt(letters.length)] +
//           numbers[random.nextInt(numbers.length)];
//       uniqueCodes.add(newCode);
//     }

//     setState(() {
//       qrCodes =
//           uniqueCodes.toList().asMap().entries.map((entry) {
//             return "S.No: ${entry.key + 1}, ID: ${entry.value}";
//           }).toList();
//       isGenerating = false;
//     });
//   }

//   /// 🖨 Save QR Codes to PDF
//   Future<void> generatePDF() async {
//     await Permission.storage.request();
//     await Permission.manageExternalStorage.request();

//     Directory? downloadsDir = Directory("/storage/emulated/0/Download");
//     if (!downloadsDir.existsSync()) {
//       downloadsDir = await getExternalStorageDirectory();
//     }

//     final pdf = pw.Document();

//     for (int i = 0; i < qrCodes.length; i++) {
//       pdf.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           build: (pw.Context context) {
//             return pw.Center(
//               child: pw.Column(
//                 mainAxisAlignment: pw.MainAxisAlignment.center,
//                 children: [
//                   pw.SizedBox(height: 10),
//                   pw.BarcodeWidget(
//                     barcode: pw.Barcode.qrCode(),
//                     data: qrCodes[i],
//                     width: 250,
//                     height: 250,
//                   ),
//                   pw.SizedBox(height: 20),
//                   pw.Text(
//                     qrCodes[i],
//                     style: pw.TextStyle(
//                       fontSize: 20,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       );
//     }

//     final now = DateTime.now();
//     final savedPath =
//         "${downloadsDir!.path}/QR_Codes_${now.day}-${now.month}-${now.year}_${now.hour}-${now.minute}-${now.second}.pdf";
//     final file = File(savedPath);
//     await file.writeAsBytes(await pdf.save());

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text("QR Code PDF saved at: $savedPath")));

//     OpenFile.open(savedPath);
//   }

//   /// 📤 Share QR as Text File
//   Future<void> shareQrCode() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final path = "${directory.path}/qr_codes.txt";
//     final file = File(path);
//     await file.writeAsString(qrCodes.join("\n"));
//     Share.shareXFiles([XFile(path)], text: "Here are my QR Codes!");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("QR Code Generator", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.teal,
//         iconTheme: IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(icon: Icon(Icons.download), onPressed: generatePDF),
//           IconButton(icon: Icon(Icons.share), onPressed: shareQrCode),
//         ],
//       ),
//       body:
//           isGenerating
//               ? Center(
//                 child: Lottie.asset(
//                   'assets/lottie/qrloading.json',
//                   width: 150,
//                   height: 150,
//                 ),
//               )
//               : SafeArea(
//                 child: Column(
//                   children: [
//                     ElevatedButton(
//                       onPressed: _askLimitDialog,
//                       child: Text("Generate New QR Codes"),
//                     ),
//                     SizedBox(height: 20),
//                     Expanded(
//                       child: GridView.builder(
//                         padding: EdgeInsets.all(12),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 10,
//                           mainAxisSpacing: 15,
//                         ),
//                         itemCount: qrCodes.length,
//                         itemBuilder: (context, index) {
//                           return Card(
//                             elevation: 5,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   QrImageView(data: qrCodes[index], size: 100),
//                                   SizedBox(height: 10),
//                                   Text(
//                                     qrCodes[index],
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }
// }
// qr_generator_screen1.dart


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_generator/demoforkumarsir/generatorqr/bloc/qrgenbloc_bloc.dart';
import 'package:qr_generator/demoforkumarsir/generatorqr/bloc/qrgenbloc_event.dart';
import 'package:qr_generator/demoforkumarsir/generatorqr/bloc/qrgenbloc_state.dart';
import 'package:share_plus/share_plus.dart';

class QRGeneratorScreen1 extends StatelessWidget {
  void _askLimitDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: "10");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("Enter number of QR codes (1–99)"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(2),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final input = int.tryParse(controller.text);
              if (input == null || input < 1 || input > 99) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please enter a number between 1 and 99")),
                );
                return;
              }
              Navigator.pop(context);
              context.read<QRGeneratorBloc>().add(GenerateQRCodes(input));
            },
            child: Text("Generate"),
          ),
        ],
      ),
    );
  }

  Future<void> _generatePDF(BuildContext context, List<String> qrCodes) async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();

    Directory? downloadsDir = Directory("/storage/emulated/0/Download");
    if (!downloadsDir.existsSync()) {
      downloadsDir = await getExternalStorageDirectory();
    }

    final pdf = pw.Document();

    for (final code in qrCodes) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (_) => pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: code,
                  width: 250,
                  height: 250,
                ),
                pw.SizedBox(height: 20),
                pw.Text(code, style: pw.TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
      );
    }

    final now = DateTime.now();
    final path = "${downloadsDir!.path}/QR_Codes_${now.millisecondsSinceEpoch}.pdf";
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PDF saved at: $path")));
    OpenFile.open(path);
  }

  Future<void> _shareQRs(List<String> codes) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/qr_codes.txt";
    final file = File(path);
    await file.writeAsString(codes.join("\n"));
    Share.shareXFiles([XFile(path)], text: "Here are my QR Codes!");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QRGeneratorBloc()..add(LoadSavedQRCodes()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("QR Code Generator", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
              builder: (context, state) {
                if (state is QRGenerated) {
                  return Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () => _generatePDF(context, state.codes),
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () => _shareQRs(state.codes),
                      ),
                      // IconButton(onPressed: () {
                      //   context.read<QRGeneratorBloc>().add(LoadSavedQRCodes());
                      // }, icon: Icon(Icons.refresh))
                    ],
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
          builder: (context, state) {
            if (state is QRGenerating) {
              return Center(
                child: Lottie.asset('assets/lottie/qrloading.json', width: 150, height: 150),
              );
            } else if (state is QRGenerated) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _askLimitDialog(context),
                    child: Text("Generate New QR Codes"),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: state.codes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              QrImageView(data: state.codes[index], size: 100),
                              SizedBox(height: 10),
                              Text(
                                state.codes[index],
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            return Center(
              child: ElevatedButton(
                onPressed: () => _askLimitDialog(context),
                child: Text("Generate QR Codes"),
              ),
            );
          },
        ),
      ),
    );
  }
}
