import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:qr_generator/grgenerator/datainput/datainputbloc.dart';
import 'package:qr_generator/grgenerator/datainput/datainputevent.dart';
import 'package:qr_generator/grgenerator/datainput/datainputstate.dart';
import 'package:qr_generator/grgenerator/qrgenerator/qrui.dart';
import 'package:qr_generator/locationservice/lcoationservice.dart';


class InputPage extends StatelessWidget {
  final List<String> selectedFields;

  const InputPage({super.key, required this.selectedFields});

  @override
  Widget build(BuildContext context) {
    final locationService = Get.find<LocationService>(); // Get location service instance

    return BlocProvider(
      create: (context) => InputBloc(selectedFields),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("QR Generator", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<InputBloc, InputState>(
            builder: (context, state) {
              return Column(
                children: [
                  const Text(
                    "Data Input",
                    style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Live Location Fields (Non-editable)
                  Obx(() {
                    final position = locationService.currentPosition.value;
                    return Column(
                      children: [
                        // _buildReadOnlyField("Latitude", position?.latitude.toString() ?? "Fetching..."),
                        // _buildReadOnlyField("Longitude", position?.longitude.toString() ?? "Fetching..."),
                        // _buildReadOnlyField("Accuracy", position?.accuracy.toInt().toString() ?? "Fetching..."),
                        _buildReadOnlyField("Accuracy", position != null ? "${position.accuracy.toInt()} M" : "Fetching..."),
                      ],
                    );
                  }),



                  const SizedBox(height: 10),

                  // Text("State Accuracy Value: ${state.isAccuracyValid ? "✅ Valid" : "❌ Invalid"}"), // ✅ Debug output

                  // Dynamic Input Fields
                  Expanded(
                    child: ListView(
                      children: selectedFields.map((field) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TextFormField(
                            initialValue: state.fieldValues[field] ?? "",
                            decoration: InputDecoration(
                              labelText: field,
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              context.read<InputBloc>().add(UpdateFieldEvent(field, value));
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Create QR Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isFormValid && state.isAccuracyValid
                          ? () {
                              context.read<InputBloc>().add(GenerateQrEvent());
                              // Navigate to QR Page after generating the QR
                              Get.to(() => BlocProvider.value(
                                    value: context.read<InputBloc>(), // Pass existing bloc
                                    child: QrPage(),
                                  )
                                  );
                            }
                          : null, // Disabled if form is empty
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:  Text(                        
                        state.isAccuracyValid ? "Create QR" : "Waiting for better Accuracy....", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper method to create non-editable fields
  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
        key: ValueKey(value), // ✅ Forces UI rebuild
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        readOnly: true, // Make the field non-editable
      ),
    );
  }
}
