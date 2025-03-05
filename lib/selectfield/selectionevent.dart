import 'package:equatable/equatable.dart';

abstract class SelectionEvent extends Equatable {
  const SelectionEvent();
  @override
  List<Object> get props => [];
}

class ToggleSelectionEvent extends SelectionEvent {
  final String card;
  const ToggleSelectionEvent(this.card);
  
  @override
  List<Object> get props => [card];
}

class AddNewCardEvent extends SelectionEvent {
  final String card;
  const AddNewCardEvent(this.card);

  @override
  List<Object> get props => [card];
}


class EditCardEvent extends SelectionEvent {
  final String oldCard;
  final String newCard;
  
  const EditCardEvent(this.oldCard, this.newCard);
  
  @override
  List<Object> get props => [oldCard, newCard];
}

class DeleteCardEvent extends SelectionEvent {
  final String card;
  
  const DeleteCardEvent(this.card);
  
  @override
  List<Object> get props => [card];
}


// class LoadFieldsEvent extends SelectionEvent {} // Load fields from storage