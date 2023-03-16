import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omega_nav/core/constants/failure_messages.dart';
import 'package:omega_nav/features/optimal_path/data/models/optimal_path_result_model.dart';
import 'package:omega_nav/features/optimal_path/data/repositories/optimal_path_repository.dart';

part 'optimal_path_event.dart';
part 'optimal_path_state.dart';

class OptimalPathBloc extends Bloc<OptimalPathEvent, OptimalPathState> {
  final OptimalPathRepository repository;

  OptimalPathBloc({required this.repository}) : super(OptimalPathInitial()) {
    on<LoadGetOptimalPathEvent>((event, emit) async {
      emit(GetOptimalPathLoading());
      final resultEither = await repository.getOptimalPath(
          event.startPointId, event.endPointId, event.modelName);
      resultEither.fold(
          (failure) => emit(
              GetOptimalPathError(errorMessage: mapFailureToMessage(failure))),
          (optimalPathResultModel) => emit(GetOptimalPathLoaded(
              optimalPathResultModel: optimalPathResultModel)));
    });
    on<LoadGenerateRouteEvent>((event, emit) async {
      emit(GeneratingRouteLoading());
      final resultEither = await repository.generateRoute(
          event.nodeLocations, event.optimalPathResultModel);
      resultEither.fold(
          (failure) => emit(
              GetOptimalPathError(errorMessage: mapFailureToMessage(failure))),
          (polyline) => emit(GeneratingRouteLoaded(polyline: polyline, optimalPathResultModel: event.optimalPathResultModel)));
    });
  }
}
