import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:omega_nav/core/constants/failure_messages.dart';
import 'package:omega_nav/features/visualize_node_values/data/models/visualize_nodes_model.dart';
import 'package:omega_nav/features/visualize_node_values/data/repositories/visualize_node_values_repository.dart';

part 'visualize_node_values_event.dart';
part 'visualize_node_values_state.dart';

class VisualizeNodeValuesBloc
    extends Bloc<VisualizeNodeValuesEvent, VisualizeNodeValuesState> {
  final VisualizeNodeValuesRepository repository;

  VisualizeNodeValuesBloc({required this.repository})
      : super(VisualizeNodeValuesInitial()) {
    on<LoadVisualizeNodeValuesEvent>((event, emit) async {
      emit(VisualizeNodeValuesLoading());
      final resultEither =
          await repository.getNodeValues(event.cycles, event.modelName);
      resultEither.fold(
          (failure) => emit(VisualizeNodeValuesError(
              errorMessage: mapFailureToMessage(failure))),
          (visualizeNodesModel) => emit(VisualizeNodeValuesLoaded(
              visualizeNodesModel: visualizeNodesModel)));
    });
  }
}
