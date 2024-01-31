import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omega_nav/core/device_information/network_info.dart';
import 'package:omega_nav/features/get_node_locations/data/data_sources/get_node_locations_remote_data_source.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';

abstract class GetNodeLocationsRepository {
  Future<Either<Failure, List<LatLng>>> getNodeLocations();
}

class GetNodeLocationsRepositoryImpl implements GetNodeLocationsRepository {
  final GetNodeLocationsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  GetNodeLocationsRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<LatLng>>> getNodeLocations() async {
    if(await networkInfo.isConnected) {
      try {
        final results = await remoteDataSource.getNodeLocations();
        return Right(results);
      } on ServerException {
        return Left(ServerFailure());
      } on SocketException {
        return Left(SocketFailure());
      } on TimeoutException {
        return Left(TimeOutFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

}