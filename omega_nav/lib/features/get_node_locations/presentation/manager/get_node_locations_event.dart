part of 'get_node_locations_bloc.dart';

abstract class GetNodeLocationsEvent extends Equatable {
  const GetNodeLocationsEvent();
}

class LoadGetNodeLocationsEvent extends GetNodeLocationsEvent {

  @override
  List<Object?> get props => [];
}
