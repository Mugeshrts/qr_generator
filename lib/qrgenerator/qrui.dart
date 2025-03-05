import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_generator/datainput/datainputbloc.dart';
import 'package:qr_generator/datainput/datainputevent.dart';
import 'package:qr_generator/datainput/datainputstate.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';



class QrPage extends StatelessWidget {
  final ScreenshotController screenshotController = ScreenshotController(); // For taking QR screenshot

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InputBloc, InputState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Generated QR Code", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.teal,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(Icons.download),
                onPressed: () => _saveQrCode(context),
              ),
              // IconButton(
              //   icon: Icon(Icons.print),
              //   onPressed: () => _printQrCode(context),
              // ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () => _shareQrCode(context),
              ),
            ],
          ),
          body: Center(
            child: state.encryptedData == null || state.encryptedData!.isEmpty
                ? const Text("No QR Code Generated", style: TextStyle(fontSize: 18))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Screenshot(
                        controller: screenshotController,
                        child: QrImageView(
                          data: state.encryptedData!, // Use Base64 encoded data
                          size: 250,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Scan this QR code to decode the data",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),

                      // Reset QR Button
                      ElevatedButton(
                        onPressed: () {
                          context.read<InputBloc>().add(ResetQrEvent());
                          Get.back(); // Go back to the input page
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Generate Another QR", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  /// Save QR code as an image
  Future<void> _saveQrCode(BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/qr_code.png";

    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        final file = File(path);
        await file.writeAsBytes(image);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("QR Code saved to: $path")),
        );
      }
    }).catchError((e) {
      print("Error saving QR Code: $e");
    });
  }

  /// Print the QR code
  // Future<void> _printQrCode(BuildContext context) async {
  //   screenshotController.capture().then((Uint8List? image) async {
  //     if (image != null) {
  //       await Printing.layoutPdf(
  //         onLayout: (format) async => image,
  //       );
  //     }
  //   }).catchError((e) {
  //     print("Error printing QR Code: $e");
  //   });
  // }

  /// Share the QR code
  Future<void> _shareQrCode(BuildContext context) async {
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final path = "${directory.path}/qr_code.png";
        final file = File(path);
        await file.writeAsBytes(image);

       Share.shareXFiles([XFile(path)], text: "Here's my QR Code!");
      }
    }).catchError((e) {
      print("Error sharing QR Code: $e");
    });
  }
}
