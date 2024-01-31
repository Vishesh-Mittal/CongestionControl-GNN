import 'dart:convert';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/urls.dart';
import '../../../../core/errors/exceptions.dart';

abstract class GetNodeLocationsRemoteDataSource {
  ///Calls the GET_NODE_LOCATIONS endpoint to get the node latitudes and longitudes.
  ///
  /// Throws a [Server Exception] for all error codes & a [Network Exception] when device is offline.
  Future<List<LatLng>> getNodeLocations();
}

class GetNodeLocationsRemoteDataSourceImpl
    implements GetNodeLocationsRemoteDataSource {
  final http.Client client;

  GetNodeLocationsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<LatLng>> getNodeLocations() async {
    final response =
        await client.get(Uri.parse(GET_NODE_LOCATIONS_URL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    }).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<LatLng> resultList = [];
      for (List nodeLocation in jsonDecode(response.body)["nodeLocations"]) {
        resultList.add(LatLng(nodeLocation[0], nodeLocation[1]));
      }
      await Future.delayed(const Duration(seconds: 2), () {});
      return resultList;
    } else {
      throw ServerException();
    }

    // Mocked response
    //   final Random rng = Random();
    //   List<List<double>> points = [
    //     [18.99406, 73.11475],
    //     [19.0007, 73.12988],
    //     [18.97477, 73.12422],
    //     [18.96325, 73.14253],
    //     [18.96617, 73.12603],
    //     [18.98325, 73.10079],
    //     [18.9926, 73.09575],
    //     [18.98592, 73.11976],
    //     [18.96445, 73.13103],
    //     [18.96811, 73.13158],
    //     [18.96074, 73.16549],
    //     [18.95606, 73.16165],
    //     [18.95882, 73.15944],
    //     [19.02687, 73.09386],
    //     [19.02373, 73.10593],
    //     [18.98311, 73.08086],
    //     [19.00048, 73.03367],
    //     [19.04384, 73.02726],
    //     [19.03163, 73.10533],
    //     [19.01862, 73.0283]
    //   ];
    //   List<LatLng> testList = [];
    //
    //   await Future.delayed(Duration(seconds: rng.nextInt(8)), () {
    //     for (List<double> point in points) {
    //       testList.add(LatLng(point[0], point[1]));
    //     }
    //   });
    //   if (rng.nextInt(100) % 4 != 0) {
    //     return testList;
    //   } else {
    //     throw ServerException();
    //   }
  }
}
