import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QRGeneratorScreen1 extends StatefulWidget {
  @override
  _QRGeneratorScreen1State createState() => _QRGeneratorScreen1State();
}

class _QRGeneratorScreen1State extends State<QRGeneratorScreen1> {
  List<String> qrCodes = [];

  @override
  void initState() {
    super.initState();
    generateQRCodes(); // Generate QR codes on screen load
  }

   /// ✅ Generates 10 unique 4-character alphanumeric codes
 void generateQRCodes() {
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const numbers = '0123456789';
  final random = Random();

  Set<String> uniqueCodes = {}; // Ensure unique codes

  while (uniqueCodes.length < 10) {
    String newCode = letters[random.nextInt(letters.length)] +
        numbers[random.nextInt(numbers.length)] +
        letters[random.nextInt(letters.length)] +
        numbers[random.nextInt(numbers.length)];

    uniqueCodes.add(newCode);
  }

  setState(() {
    // ✅ Modify QR data format: Add S.No. to the stored data
    qrCodes = uniqueCodes.toList().asMap().entries.map((entry) {
      return "S.No: ${entry.key + 1}, ID: ${entry.value}";
    }).toList();
  });
}

  /// 🖨 **Generate & Save QR Code PDF (Each QR on a New Page)**
  Future<void> generatePDF() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();

    Directory? downloadsDir = Directory("/storage/emulated/0/Download");
    if (!downloadsDir.existsSync()) {
      downloadsDir = await getExternalStorageDirectory();
    }

    final pdf = pw.Document();

   for (int i = 0; i < qrCodes.length; i++) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  // pw.Text("S.No: ${i + 1}", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: qrCodes[i], // ✅ Now QR contains S.No. + ID
                    width: 250,
                    height: 250,
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(qrCodes[i], style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            );
          },
        ),
      );
    }

    final now = DateTime.now();
    final formattedDate = "${now.day}-${now.month}-${now.year}";
    final formattedTime = "${now.hour}:${now.minute}:${now.second}";

    final savedPath = "${downloadsDir!.path}/QR_Codes_${formattedDate}_${now.hour}-${now.minute}-${now.second}.pdf";
    final file = File(savedPath);
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("QR Code PDF saved at: $savedPath")),
    );

    OpenFile.open(savedPath); // Open PDF automatically
  }

 /// 📤 **Share QR Code as Image**
  Future<void> shareQrCode() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/qr_codes.txt";

    final file = File(path);
    await file.writeAsString(qrCodes.join("\n"));

    Share.shareXFiles([XFile(path)], text: "Here are my QR Codes!");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR Code Generator", style: TextStyle(color: Colors.white),), backgroundColor: Colors.teal,
      iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: generatePDF, // 🖨 Save as PDF
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: shareQrCode, // 📤 Share QR Codes
          ),
        ],
      ),
      body: SafeArea(
        // padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: generateQRCodes,
              child: Text("Generate New QR Codes"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Show 2 QR codes per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 15,
                ),
                itemCount: qrCodes.length,
                itemBuilder: (context, index) {
                  return Card(      
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //  Text("S.No: ${index + 1}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // SizedBox(height: 5),
                          QrImageView(
                            data: qrCodes[index],
                            size: 100,
                          ),
                          SizedBox(height: 10),
                          Text(qrCodes[index], style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
