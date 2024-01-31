import 'package:equatable/equatable.dart';

class OptimalPathResultModel extends Equatable {
  final String startPointId;
  final String endPointId;
  final List<String> pathOfIds;
  final num estimatedTime;

  const OptimalPathResultModel(
      {required this.startPointId,
      required this.endPointId,
      required this.pathOfIds,
      required this.estimatedTime});

  @override
  List<Object?> get props =>
      [startPointId, endPointId, pathOfIds, estimatedTime];

  factory OptimalPathResultModel.fromJson(Map<String, dynamic> json) {
    List<String> _castedPath = [];

    for(String element in json["path"]) {
      _castedPath.add(element);
    }
    return OptimalPathResultModel(
        endPointId: json["endPoint"],
        estimatedTime: json["estimatedTime"],
        pathOfIds: _castedPath,
        startPointId: json["startPoint"]);
  }
}
