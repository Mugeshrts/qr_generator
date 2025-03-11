import 'package:equatable/equatable.dart';

class SelectionState extends Equatable {
  final List<String> textCards;
  final Set<String> selectedCards;

  const SelectionState({required this.textCards, required this.selectedCards});

  factory SelectionState.initial() {
    return SelectionState(textCards: ["Name", "Email", "Phone"], selectedCards: {});
  }

  SelectionState copyWith({List<String>? textCards, Set<String>? selectedCards}) {
    return SelectionState(
      textCards: textCards ?? this.textCards,
      selectedCards: selectedCards ?? this.selectedCards,
    );
  }

  @override
  List<Object> get props => [textCards, selectedCards];
}
