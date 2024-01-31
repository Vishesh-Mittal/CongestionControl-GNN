import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/secrets.dart';
import '../models/optimal_path_result_model.dart';

import '../../../../core/constants/urls.dart';
import '../../../../core/errors/exceptions.dart';

abstract class OptimalPathRemoteDataSource {
  ///Calls the GET_OPTIMAL_PATH endpoint to get the optimal route.
  ///
  /// Throws a [Server Exception] for all error codes & a [Network Exception] when device is offline.
  Future<OptimalPathResultModel> getOptimalPath(
      String startPointId, String endPointId, String modelName);
  Future<Polyline> generateRoute(List<LatLng> nodeLocations,
      OptimalPathResultModel optimalPathResultModel);
}

class OptimalPathRemoteDataSourceImpl implements OptimalPathRemoteDataSource {
  final PolylinePoints polylinePoints;
  final http.Client client;

  OptimalPathRemoteDataSourceImpl(
      {required this.polylinePoints, required this.client});

  @override
  Future<OptimalPathResultModel> getOptimalPath(
      String startPointId, String endPointId, String modelName) async {
    final response = await client
        .post(Uri.parse(OPTIMAL_PATH_URL),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              "startPointId": int.parse(startPointId),
              "endPointId": int.parse(endPointId),
              "modelName": modelName
            }))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return OptimalPathResultModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }

    // final Random rng = Random();
    // late OptimalPathResultModel testModel;
    //
    // await Future.delayed(Duration(seconds: rng.nextInt(8)), () {
    //   testModel = OptimalPathResultModel(
    //       startPointId: startPointId,
    //       endPointId: endPointId,
    //       pathOfIds: [startPointId, "1", "2", "5", "3", endPointId],
    //       estimatedTime: 24);
    // });
    // if (rng.nextInt(100) % 4 != 0) {
    //   return testModel;
    // } else {
    //   throw ServerException();
    // }
  }

  @override
  Future<Polyline> generateRoute(List<LatLng> nodeLocations,
      OptimalPathResultModel optimalPathResultModel) async {
    LatLng startPoint =
        nodeLocations[int.parse(optimalPathResultModel.startPointId)];
    LatLng endPoint =
        nodeLocations[int.parse(optimalPathResultModel.endPointId)];
    List<LatLng> path = optimalPathResultModel.pathOfIds
        .sublist(1, optimalPathResultModel.pathOfIds.length - 1)
        .map((e) => nodeLocations[int.parse(e)])
        .toList();

    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GOOGLE_CLOUD_API_KEY,
        PointLatLng(startPoint.latitude, startPoint.longitude),
        PointLatLng(endPoint.latitude, endPoint.longitude),
        wayPoints: path
            .map((e) =>
                PolylineWayPoint(location: "${e.latitude}, ${e.longitude}"))
            .toList());

    if (result.status == "OK") {
      for (PointLatLng point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      return Polyline(
          width: 6,
          startCap: Cap.roundCap,
          polylineId: PolylineId(
              "${optimalPathResultModel.startPointId} to ${optimalPathResultModel.endPointId}"),
          color: const Color(0xFF000000),
          points: polylineCoordinates);
    } else {
      throw ServerException();
    }
  }
}
