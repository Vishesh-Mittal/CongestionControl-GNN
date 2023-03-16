import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data_sources/optimal_path_remote_data_source.dart';

import '../models/optimal_path_result_model.dart';

import '../../../../core/device_information/network_info.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';

abstract class OptimalPathRepository {
  Future<Either<Failure, OptimalPathResultModel>> getOptimalPath(String startPointId, String endPointId, String modelName);
  Future<Either<Failure, Polyline>> generateRoute(List<LatLng> nodeLocations, OptimalPathResultModel optimalPathResultModel);
}

class OptimalPathRepositoryImpl implements OptimalPathRepository {
  final OptimalPathRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OptimalPathRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, OptimalPathResultModel>> getOptimalPath(String startPointId, String endPointId, String modelName) async {
    if(await networkInfo.isConnected) {
      try {
        final results = await remoteDataSource.getOptimalPath(startPointId, endPointId, modelName);
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

  @override
  Future<Either<Failure, Polyline>> generateRoute(List<LatLng> nodeLocations, OptimalPathResultModel optimalPathResultModel) async {
    if(await networkInfo.isConnected) {
      try {
        final results = await remoteDataSource.generateRoute(nodeLocations, optimalPathResultModel);
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