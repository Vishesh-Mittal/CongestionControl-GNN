import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../../../../core/constants/urls.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/visualize_nodes_model.dart';

abstract class VisualizeNodeValuesRemoteDataSource {
  ///Calls the GET_NODE_VALUES endpoint to get the speed values for all nodes for given number of cycles.
  ///
  /// Throws a [Server Exception] for all error codes & a [Network Exception] when device is offline.
  Future<VisualizeNodesModel> getNodeValues(int cycles, String modelName);
}

class VisualizeNodeValuesRemoteDatSourceImpl implements VisualizeNodeValuesRemoteDataSource {
  final http.Client client;

  VisualizeNodeValuesRemoteDatSourceImpl({required this.client});

  @override
  Future<VisualizeNodesModel> getNodeValues(int cycles, String modelName) async {
    // final response = await client
    //     .post(Uri.parse(GET_DATA_POINTS_FOR_VISUALIZATION_URL),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //     },
    //     body: jsonEncode({"cycles": cycles, "modelName": modelName}))
    //     .timeout(const Duration(seconds: 10));
    //
    // if (response.statusCode == 200) {
    //   return VisualizeNodesModel.fromJson(jsonDecode(response.body));
    // } else {
    //   throw ServerException();
    // }

    final Random rng = Random();
    late VisualizeNodesModel testModel;

    await Future.delayed(Duration(seconds: rng.nextInt(4)), () {
      List<List<double>> fullCycleResultList = [];
      for(int i = 0; i < 20; i++) {
        List<double> oneCycleResultList = [];
        for(int j=0; j < cycles; j++) {
          oneCycleResultList.add(rng.nextDouble() * 100);
        }
        fullCycleResultList.add(oneCycleResultList);
      }

      print(fullCycleResultList.length);
      testModel = VisualizeNodesModel(
          startTime: DateTime(2017, 9, 7, 17, 30),
          endTime: DateTime(2018, 9, 7, 17, 30),
          nodeSpeedValues: fullCycleResultList
      );
    });
    return testModel;
  }

}
