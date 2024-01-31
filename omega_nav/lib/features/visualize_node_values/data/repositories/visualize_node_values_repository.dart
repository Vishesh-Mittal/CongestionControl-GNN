import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../data_sources/visualize_node_values_remote_data_source.dart';

import '../models/visualize_nodes_model.dart';

import '../../../../core/device_information/network_info.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';

abstract class VisualizeNodeValuesRepository {
  Future<Either<Failure, VisualizeNodesModel>> getNodeValues(
      int cycles, String modelName);
}

class VisualizeNodeValuesRepositoryImpl
    implements VisualizeNodeValuesRepository {
  final VisualizeNodeValuesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  VisualizeNodeValuesRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, VisualizeNodesModel>> getNodeValues(
      int cycles, String modelName) async {
    if (await networkInfo.isConnected) {
      try {
        final results = await remoteDataSource.getNodeValues(cycles, modelName);
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
