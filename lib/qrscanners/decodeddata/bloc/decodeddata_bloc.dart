import 'dart:convert';
import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_generator/qrscanners/decodeddata/bloc/decodeddata_event.dart';
import 'package:qr_generator/qrscanners/decodeddata/bloc/decodeddata_state.dart';
import 'package:share_plus/share_plus.dart';


class ScannedDataBloc extends Bloc<ScannedDataEvent, ScannedDataState> {
  ScannedDataBloc() : super(ScannedDataInitial()) {
    on<DecodeScannedData>(_onDecodeScannedData);
    on<ShareScannedData>(_onShareScannedData);
    on<SaveDataAsPdf>(_onSaveDataAsPdf);
    on<CopyToClipboard>(_onCopyToClipboard);
  }

  void _onDecodeScannedData(DecodeScannedData event, Emitter<ScannedDataState> emit) {
    try {
      final decodedJson = jsonDecode(utf8.decode(base64Decode(event.scannedData))) as Map<String, dynamic>;
      Map<String, String> decodedFields = {};
      decodedJson.forEach((key, value) => decodedFields[key] = value.toString());
      emit(ScannedDataLoaded(decodedFields));
    } catch (e) {
      emit(ScannedDataLoaded({"Scanned Data": event.scannedData}));
    }
  }

  Future<void> _onShareScannedData(ShareScannedData event, Emitter<ScannedDataState> emit) async {
    if (state is ScannedDataLoaded) {
      final scannedData = (state as ScannedDataLoaded).decodedFields;
      String text = scannedData.entries.map((e) => "${e.key}: ${e.value}").join("\n");
      await Share.share(text);
    }
  }

  Future<void> _onSaveDataAsPdf(SaveDataAsPdf event, Emitter<ScannedDataState> emit) async {
    if (state is ScannedDataLoaded) {
      emit(ScannedDataSaving());
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();

      Directory? downloadsDir = Directory("/storage/emulated/0/Download");
      if (!downloadsDir.existsSync()) {
        downloadsDir = await getExternalStorageDirectory();
      }

      final pdf = pw.Document();
      final now = DateTime.now();
      final formattedDate = "${now.day}-${now.month}-${now.year}";

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                ...((state as ScannedDataLoaded).decodedFields.entries)
                    .map((entry) => pw.Text("${entry.key}: ${entry.value}", style: pw.TextStyle(fontSize: 16))),
              ],
            );
          },
        ),
      );

      final savedPath = "${downloadsDir!.path}/ScannedData_$formattedDate.pdf";
      final file = File(savedPath);
      await file.writeAsBytes(await pdf.save());

      emit(ScannedDataSaved(savedPath));
    }
  }

  void _onCopyToClipboard(CopyToClipboard event, Emitter<ScannedDataState> emit) {
  FlutterClipboard.copy(event.text).then((_) {
    print("✅ Text copied to clipboard!");
  });
}
}
