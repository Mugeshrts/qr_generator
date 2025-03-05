import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:qr_generator/datainput/datainputbloc.dart';
import 'package:qr_generator/datainput/datainputevent.dart';
import 'package:qr_generator/datainput/datainputstate.dart';
import 'package:qr_generator/qrgenerator/qrui.dart';


class InputPage extends StatelessWidget {
  final List<String> selectedFields;

  const InputPage({Key? key, required this.selectedFields}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InputBloc(selectedFields),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("QR generator", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<InputBloc, InputState>(
            builder: (context, state) {
              return Column(
                children: [
                  Text("Data input",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Expanded(
                    child: ListView(
                      children: selectedFields.map((field) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TextFormField(
                            initialValue: state.fieldValues[field] ?? "",
                            decoration: InputDecoration(
                              labelText: field,
                              border: OutlineInputBorder(),
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
                      onPressed: state.isFormValid
                          ? () {
                              context.read<InputBloc>().add(GenerateQrEvent());

                              // Navigate to QR Page after generating the QR
                              Get.to(() => BlocProvider.value(
                                value: context.read<InputBloc>(), // Pass existing bloc
                                child: QrPage(),
                              ));
                            }
                          : null, // Disabled if form is empty
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Create QR", style: TextStyle(fontSize: 18)),
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
}
