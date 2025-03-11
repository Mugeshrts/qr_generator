import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_generator/qrscanners/qrscanner/qrscanui.dart';
import 'package:share_plus/share_plus.dart';

class ScannedDataPage extends StatefulWidget {
  final String scannedData;

  const ScannedDataPage({Key? key, required this.scannedData}) : super(key: key);

  @override
  _ScannedDataPageState createState() => _ScannedDataPageState();
}

class _ScannedDataPageState extends State<ScannedDataPage> {
  Map<String, String> decodedFields = {};
  // List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    _decodeData();
  }

  void _decodeData() {
    try {
      final decodedJson = jsonDecode(utf8.decode(base64Decode(widget.scannedData))) as Map<String, dynamic>;
      decodedJson.forEach((key, value) {
        decodedFields[key] = value.toString();
        // controllers.add(TextEditingController(text: value.toString()));
      });
    } catch (e) {
      decodedFields["Scanned Data"] = widget.scannedData;
      // controllers.add(TextEditingController(text: widget.scannedData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanned Data", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.to(() => QrScannerPage()), // Navigate back to scanner
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => _shareData(),
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => _saveDataAsPdf(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: decodedFields.length,
          itemBuilder: (context, index) {
            String key = decodedFields.keys.elementAt(index);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TextFormField(
                readOnly: true, // 🛑 Make field non-editable
                initialValue: decodedFields[key],
                decoration: InputDecoration(
                  labelText: key,
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      _copyToClipboard(decodedFields[key]!);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Copy Text to Clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied to Clipboard!")));
  }


  /// Share Scanned Data
  Future<void> _shareData() async {
    String text = decodedFields.entries.map((e) => "${e.key}: ${e.value}").join("\n");
    await Share.share(text);
  }

  /// Save Scanned Data as a PDF
  Future<void> _saveDataAsPdf() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();

    Directory? downloadsDir = Directory("/storage/emulated/0/Download");
    if (!downloadsDir.existsSync()) {
      downloadsDir = await getExternalStorageDirectory();
    }

    final pdf = pw.Document();
    final now = DateTime.now();
    final formattedDate = "${now.day}-${now.month}-${now.year}";
    final formattedTime = "${now.hour}:${now.minute}:${now.second}";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // pw.Text("Scanned QR Code Data", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              ...decodedFields.entries.map((entry) => pw.Text("${entry.key}: ${entry.value}", style: pw.TextStyle(fontSize: 16))),
              pw.SizedBox(height: 20),
              // pw.Text("Saved on: $formattedDate at $formattedTime", style: pw.TextStyle(fontSize: 14)),
            ],
          );
        },
      ),
    );

    final savedPath = "${downloadsDir!.path}/ScannedData_${formattedDate}_${now.hour}-${now.minute}-${now.second}.pdf";
    final file = File(savedPath);
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Scanned data PDF saved at: $savedPath")),
    );

    OpenFile.open(savedPath); // Open the saved PDF file
  }
}
