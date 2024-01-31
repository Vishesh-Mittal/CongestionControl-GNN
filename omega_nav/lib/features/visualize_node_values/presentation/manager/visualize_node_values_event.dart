part of 'visualize_node_values_bloc.dart';

abstract class VisualizeNodeValuesEvent extends Equatable {
  const VisualizeNodeValuesEvent();
}

class LoadVisualizeNodeValuesEvent extends VisualizeNodeValuesEvent {
  final int cycles;
  final String modelName;

  const LoadVisualizeNodeValuesEvent({required this.cycles, required this.modelName});

  @override
  List<Object?> get props => [cycles, modelName];
}
