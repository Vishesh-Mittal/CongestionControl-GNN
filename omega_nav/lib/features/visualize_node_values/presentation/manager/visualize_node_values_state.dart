part of 'visualize_node_values_bloc.dart';

abstract class VisualizeNodeValuesState extends Equatable {
  const VisualizeNodeValuesState();

  @override
  List<Object> get props => [];
}

class VisualizeNodeValuesInitial extends VisualizeNodeValuesState {}

class VisualizeNodeValuesLoading extends VisualizeNodeValuesState {}

class VisualizeNodeValuesLoaded extends VisualizeNodeValuesState {
  final VisualizeNodesModel visualizeNodesModel;

  const VisualizeNodeValuesLoaded({required this.visualizeNodesModel});

  @override
  List<Object> get props => [visualizeNodesModel];
}

class VisualizeNodeValuesError extends VisualizeNodeValuesState {
  final String errorMessage;

  const VisualizeNodeValuesError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
