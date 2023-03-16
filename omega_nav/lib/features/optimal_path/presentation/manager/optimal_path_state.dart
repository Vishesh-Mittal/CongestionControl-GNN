part of 'optimal_path_bloc.dart';

abstract class OptimalPathState extends Equatable {
  const OptimalPathState();

  @override
  List<Object> get props => [];
}

class OptimalPathInitial extends OptimalPathState {}

class GetOptimalPathLoading extends OptimalPathState {}

class GetOptimalPathLoaded extends OptimalPathState {
  final OptimalPathResultModel optimalPathResultModel;

  const GetOptimalPathLoaded({required this.optimalPathResultModel});

  @override
  List<Object> get props => [optimalPathResultModel];
}

class GeneratingRouteLoading extends OptimalPathState {}

class GeneratingRouteLoaded extends OptimalPathState {
  final Polyline polyline;
  final OptimalPathResultModel optimalPathResultModel;

  const GeneratingRouteLoaded({required this.polyline, required this.optimalPathResultModel});

  @override
  List<Object> get props => [polyline];
}

class GetOptimalPathError extends OptimalPathState {
  final String errorMessage;

  const GetOptimalPathError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
