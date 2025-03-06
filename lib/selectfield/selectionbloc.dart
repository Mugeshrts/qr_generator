import 'package:bloc/bloc.dart';
import 'package:qr_generator/selectfield/selectionevent.dart';
import 'package:qr_generator/selectfield/selectionstate.dart';


// class SelectionBloc extends Bloc<SelectionEvent, SelectionState> {
//   final GetStorage _storage = GetStorage();

//   SelectionBloc() : super(SelectionState.initial()) {

//     // Load stored fields on startup
//     on<LoadFieldsEvent>((event, emit) {
//        List<String>? storedFields = _storage.read<List<String>>('textCards');
//        if (storedFields == null || storedFields.isEmpty) {
//         // If no fields exist, set predefined values
//         storedFields = ["Name", "Email", "Phone"];
//         _storage.write('textCards', storedFields); // Save to storage
//       }

//       emit(SelectionState(textCards: storedFields, selectedCards: {}));
//     });


//     on<ToggleSelectionEvent>((event, emit) {
//       final updatedSelection = Set<String>.from(state.selectedCards);
//       if (updatedSelection.contains(event.card)) {
//         updatedSelection.remove(event.card);
//       } else {
//         updatedSelection.add(event.card);
//       }
//       emit(state.copyWith(selectedCards: updatedSelection));
//     });

//     on<AddNewCardEvent>((event, emit) {
//       if (event.card.isNotEmpty && !state.textCards.contains(event.card)) {
//         final updatedCards = List<String>.from(state.textCards)..add(event.card);
//          _storage.write('textCards', updatedCards); // Save to storageZ
//         emit(state.copyWith(textCards: updatedCards));
//       }
//     });

//     on<EditCardEvent>((event, emit){
//    final updatedCards = List<String>.from(state.textCards);
//    final index = updatedCards.indexOf(event.oldCard);
//    if(index != -1){
//     updatedCards[index] = event.newCard;
//    }
//    emit(state.copyWith(textCards: updatedCards));
//     });

//      on<DeleteCardEvent>((event, emit) {
//       final updatedCards = List<String>.from(state.textCards)..remove(event.card);
//       final updatedSelection = Set<String>.from(state.selectedCards)..remove(event.card);
//       emit(state.copyWith(textCards: updatedCards, selectedCards: updatedSelection));
//     });
//   }
// }


class SelectionBloc extends Bloc<SelectionEvent, SelectionState> {
  SelectionBloc() : super(SelectionState.initial()) {
    on<ToggleSelectionEvent>((event, emit) {
      final updatedSelection = Set<String>.from(state.selectedCards);
      if (updatedSelection.contains(event.card)) {
        updatedSelection.remove(event.card);
      } else {
        updatedSelection.add(event.card);
      }
      emit(state.copyWith(selectedCards: updatedSelection));
    });

    on<AddNewCardEvent>((event, emit) {
      if (event.card.isNotEmpty && !state.textCards.contains(event.card)) {
        final updatedCards = List<String>.from(state.textCards)..add(event.card);
        emit(state.copyWith(textCards: updatedCards));
      }
    });

    on<EditCardEvent>((event, emit) {
      final updatedCards = List<String>.from(state.textCards);
      final index = updatedCards.indexOf(event.oldCard);
      if (index != -1) {
        updatedCards[index] = event.newCard;
      }
      emit(state.copyWith(textCards: updatedCards));
    });

    on<DeleteCardEvent>((event, emit) {
      final updatedCards = List<String>.from(state.textCards)..remove(event.card);
      final updatedSelection = Set<String>.from(state.selectedCards)..remove(event.card);
      emit(state.copyWith(textCards: updatedCards, selectedCards: updatedSelection));
    });
  }
}

