import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:qr_generator/grgenerator/datainput/datainputui.dart';
import 'package:qr_generator/grgenerator/selectfield/selectionbloc.dart';
import 'package:qr_generator/grgenerator/selectfield/selectionevent.dart';
import 'package:qr_generator/grgenerator/selectfield/selectionstate.dart';

class SelectionPage extends StatelessWidget {
  final TextEditingController newCardController = TextEditingController();

  SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR generator", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => _showAddFieldDialog(context),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: 
        BlocBuilder<SelectionBloc, SelectionState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 10),
                Text("Select field",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                const SizedBox(height: 10),
                
                // Display selected cards in a Row
                // if (state.selectedCards.isNotEmpty)
                //   SingleChildScrollView(
                //     scrollDirection: Axis.horizontal,
                //     child: Row(
                //       children: state.selectedCards.map((text) {
                //         return Container(
                //           margin: const EdgeInsets.symmetric(horizontal: 4),
                //           padding: const EdgeInsets.all(8),
                //           decoration: BoxDecoration(
                //             color: Colors.blue,
                //             borderRadius: BorderRadius.circular(8),
                //           ),
                //           child: Text(
                //             text,
                //             style: const TextStyle(fontSize: 16, color: Colors.white),
                //           ),
                //         );
                //       }).toList(),
                //     ),
                //   ),
        
                // const SizedBox(height: 10),
        
                // Show available cards
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Adjust to fit your UI needs
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3, // Adjusted aspect ratio for better UI
                    ),
                    itemCount: state.textCards.length,
                    itemBuilder: (context, index) {
                      String text = state.textCards[index];
                      bool isSelected = state.selectedCards.contains(text);
        
                      return GestureDetector(
                        onTap: () => context.read<SelectionBloc>().add(ToggleSelectionEvent(text)),
                        onDoubleTap: () => _showEditFieldDialog(context, text),   
                        onLongPress: () => _showDeleteConfirmation(context, text),
                        child: Card(
                          color: isSelected ? Colors.teal : Colors.white,
                          child: Center(
                            child: Text(
                              text,
                              style: TextStyle(fontSize: 18, color: isSelected ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        
                // Adjusted ElevatedButton size
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.selectedCards.isNotEmpty
                          ? () {
                             Get.to(() =>InputPage(selectedFields: state.selectedCards.toList()));
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14), // Adjusted button height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          
                        ),
                      ),
                      child: const Text("Next", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
  }

  // Function to show the popup dialog for adding a new field
  void _showAddFieldDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Field"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Field Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<SelectionBloc>().add(AddNewCardEvent(controller.text));
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
    // Function to show the popup dialog for editing a field name
  void _showEditFieldDialog(BuildContext context, String oldText) {
    final TextEditingController controller = TextEditingController(text: oldText);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Field Name"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "New Field Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty && controller.text != oldText) {
                  context.read<SelectionBloc>().add(EditCardEvent(oldText, controller.text));
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

   // Function to show a delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context, String card) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Field"),
          content: Text("Are you sure you want to delete \"$card\"?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                context.read<SelectionBloc>().add(DeleteCardEvent(card));
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
