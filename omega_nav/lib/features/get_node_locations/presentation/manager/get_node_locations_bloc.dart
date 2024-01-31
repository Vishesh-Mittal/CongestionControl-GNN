import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omega_nav/core/constants/failure_messages.dart';
import 'package:omega_nav/features/get_node_locations/data/repositories/get_node_locations_repository.dart';

part 'get_node_locations_event.dart';
part 'get_node_locations_state.dart';

class GetNodeLocationsBloc
    extends Bloc<GetNodeLocationsEvent, GetNodeLocationsState> {
  final GetNodeLocationsRepository repository;

  GetNodeLocationsBloc({required this.repository})
      : super(GetNodeLocationsInitial()) {
    on<LoadGetNodeLocationsEvent>((event, emit) async {
      emit(GetNodeLocationsLoading());
      final resultEither = await repository.getNodeLocations();
      resultEither.fold(
          (failure) => emit(GetNodeLocationsError(
              errorMessage: mapFailureToMessage(failure))),
          (nodeLocationsList) => emit(
              GetNodeLocationsLoaded(nodeLocationsList: nodeLocationsList)));
    });
  }
}
