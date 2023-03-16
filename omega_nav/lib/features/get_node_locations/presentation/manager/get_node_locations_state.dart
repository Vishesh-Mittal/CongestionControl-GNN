part of 'get_node_locations_bloc.dart';

abstract class GetNodeLocationsState extends Equatable {
  const GetNodeLocationsState();

  @override
  List<Object> get props => [];
}

class GetNodeLocationsInitial extends GetNodeLocationsState {}

class GetNodeLocationsLoading extends GetNodeLocationsState {}

class GetNodeLocationsLoaded extends GetNodeLocationsState {
  final List<LatLng> nodeLocationsList;

  const GetNodeLocationsLoaded({required this.nodeLocationsList});

  @override
  List<Object> get props => [nodeLocationsList];
}
class GetNodeLocationsError extends GetNodeLocationsState {
  final String errorMessage;

  const GetNodeLocationsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}