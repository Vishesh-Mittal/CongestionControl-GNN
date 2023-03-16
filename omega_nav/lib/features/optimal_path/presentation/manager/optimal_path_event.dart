part of 'optimal_path_bloc.dart';

abstract class OptimalPathEvent extends Equatable {
  const OptimalPathEvent();
}

class LoadGetOptimalPathEvent extends OptimalPathEvent {
  final String startPointId;
  final String endPointId;
  final String modelName;

  const LoadGetOptimalPathEvent({required this.startPointId, required this.endPointId, required this.modelName});

  @override
  List<Object?> get props => [startPointId, endPointId, modelName];
}

class LoadGenerateRouteEvent extends OptimalPathEvent {
  final List<LatLng> nodeLocations;
  final OptimalPathResultModel optimalPathResultModel;

  const LoadGenerateRouteEvent({required this.nodeLocations, required this.optimalPathResultModel});

  @override
  List<Object?> get props => [nodeLocations, optimalPathResultModel];
}